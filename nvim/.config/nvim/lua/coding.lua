-- ============================================================
-- CODING.LUA
-- This file contains everything that makes writing code
-- smoother. Think LSPs, completions, formatting, git, ...
-- ============================================================

-- Automatically choose correct indentation depending on context.
do
	vim.pack.add({ "https://github.com/tpope/vim-sleuth" })
end

-- Treesitter.
do
	vim.pack.add({ { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" } })

	local parsers = {
		"bash",
		"c",
		"diff",
		"gitcommit",
		"html",
		"lua",
		"luadoc",
		"markdown",
		"markdown_inline",
		"nix",
		"python",
		"query",
		"rust",
		"scala",
		"vim",
		"vimdoc",
	}

	local ts = require("nvim-treesitter")
	ts.install(parsers)

	---@param buf integer
	---@param language string
	local function treesitter_try_attach(buf, language)
		-- Check if a parser exists and load it
		if not vim.treesitter.language.add(language) then
			return
		end

		-- Enable syntax highlighting and other treesitter features
		vim.treesitter.start(buf, language)

		-- Check if treesitter indentation is available for this language, and if so
		-- enable it in case there is no indent query, the indentexpr will fallback
		-- to the vim's built in one
		local has_indent_query = vim.treesitter.query.get(language, "indents") ~= nil

		-- Enable treesitter based indentation
		if has_indent_query then
			vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
		end
	end

	local available_parsers = ts.get_available()
	vim.api.nvim_create_autocmd("FileType", {
		callback = function(args)
			local buf, filetype = args.buf, args.match

			local language = vim.treesitter.language.get_lang(filetype)
			if not language then
				return
			end

			local installed_parsers = ts.get_installed("parsers")

			if vim.tbl_contains(installed_parsers, language) then
				-- Enable the parser if it is already installed
				treesitter_try_attach(buf, language)
			elseif vim.tbl_contains(available_parsers, language) then
				-- If a parser is available in `nvim-treesitter`,
				-- auto-install it and enable it after the installation
				-- is done
				ts.install(language):await(function()
					treesitter_try_attach(buf, language)
				end)
			else
				-- Try to enable treesitter features in case the parser
				-- exists but is not available from `nvim-treesitter`
				treesitter_try_attach(buf, language)
			end
		end,
	})
end

-- Git blame pane.
do
	vim.pack.add({ "https://github.com/FabijanZulj/blame.nvim" })

	require("blame").setup()
	vim.keymap.set("n", "<leader>gb", "<cmd>BlameToggle<cr>")
end

-- Formatting.
do
	vim.pack.add({ "https://github.com/stevearc/conform.nvim" })

	local conform = require("conform")
	conform.setup({
		notify_on_error = true,
		default_format_opts = {
			lsp_format = "fallback",
		},
		formatters_by_ft = {
			bash = { "shellcheck" },
			json = { "jq" },
			jsonc = { "jq" },
			lua = { "stylua" },
			nix = { "nixfmt" },
			python = { "isort", "autopep8" },
			rust = { "rustfmt" },
			scala = { "scalafmt" },
			sh = { "shellcheck" },
		},
	})

	vim.keymap.set({ "n", "v" }, "<leader>ri", function()
		conform.format({ async = true })
	end)
end

-- Completions.
do
	vim.pack.add({ { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1.*") } })

	require("blink.cmp").setup({
		keymap = {
			-- :h blink-cmp-config-keymap
			preset = "default",
		},
		appearance = {
			nerd_font_variant = "mono",
		},
		completion = {
			documentation = { auto_show = true, auto_show_delay_ms = 500 },
		},
		sources = {
			per_filetype = {},
			default = { "lsp", "path", "snippets", "lazydev", "buffer" },
			providers = {
				lazydev = { module = "lazydev.integrations.blink", score_offset = 100 },
			},
		},
		fuzzy = { implementation = "lua" },
		signature = { enabled = true },
	})
end

-- LSPs.
do
	vim.pack.add({
		"https://github.com/nvim-lua/plenary.nvim",
		"https://github.com/nvim-telescope/telescope.nvim",
		"https://github.com/j-hui/fidget.nvim",
		{ src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1.*") },
		"https://github.com/neovim/nvim-lspconfig",
	})

	-- Bring back useful LSP commands.
	vim.api.nvim_create_user_command("LspStart", ":lsp enable", {})
	vim.api.nvim_create_user_command("LspStop", ":lsp stop", {})
	vim.api.nvim_create_user_command("LspRestart", ":lsp restart", {})
	vim.api.nvim_create_user_command("LspInfo", ":checkhealth lsp", {})

	-- Provides LSP progress messages.
	require("fidget").setup({
		notification = {
			window = {
				winblend = 0,
			},
		},
	})

	-- Show hex colours codes.
	vim.lsp.document_color.enable()

	vim.api.nvim_create_autocmd("LspAttach", {
		group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
		callback = function(event)
			local map = function(keys, func, mode)
				mode = mode or "n"
				vim.keymap.set(mode, keys, func, { buffer = event.buf })
			end

			map("<leader>h", vim.lsp.buf.hover)
			map("<leader>rn", vim.lsp.buf.rename)
			map("<leader>ca", vim.lsp.buf.code_action, { "n", "x" }) -- quick fix

			local telescope = require("telescope.builtin")
			map("<leader>gr", telescope.lsp_references)
			map("<leader>gi", telescope.lsp_implementations)
			map("gd", telescope.lsp_definitions) --  To jump back, press <C-t>.
			map("gD", vim.lsp.buf.declaration)
			map("gO", telescope.lsp_document_symbols)
			map("gW", telescope.lsp_dynamic_workspace_symbols)
			map("gt", telescope.lsp_type_definitions)

			-- The following two autocommands are used to highlight references of the
			-- word under your cursor when your cursor rests there for a little while.
			--    See `:help CursorHold` for information about when this is executed
			--
			-- When you move your cursor, the highlights will be cleared (the second autocommand).
			local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
			local client = vim.lsp.get_client_by_id(event.data.client_id)
			if
				client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf)
			then
				vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
					buffer = event.buf,
					group = highlight_augroup,
					callback = vim.lsp.buf.document_highlight,
				})

				vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
					buffer = event.buf,
					group = highlight_augroup,
					callback = vim.lsp.buf.clear_references,
				})

				vim.api.nvim_create_autocmd("LspDetach", {
					group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
					callback = function(event2)
						vim.lsp.buf.clear_references()
						vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
					end,
				})
			end

			-- The following code creates a keymap to toggle inlay hints in your
			-- code, if the language server you are using supports them
			--
			-- This may be unwanted, since they displace some of your code
			if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
				map("<leader>th", function()
					vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
				end)
			end
		end,
	})

	-- Diagnostic Config
	-- See :help vim.diagnostic.Opts
	vim.diagnostic.config({
		severity_sort = true,
		float = { border = "rounded", source = "if_many" },
		underline = { severity = vim.diagnostic.severity.ERROR },
		signs = {
			text = {
				[vim.diagnostic.severity.ERROR] = "󰅚 ",
				[vim.diagnostic.severity.WARN] = "󰀪 ",
				[vim.diagnostic.severity.INFO] = "󰋽 ",
				[vim.diagnostic.severity.HINT] = "󰌶 ",
			},
		},
		virtual_text = {
			source = "if_many",
			spacing = 2,
			format = function(diagnostic)
				local diagnostic_message = {
					[vim.diagnostic.severity.ERROR] = diagnostic.message,
					[vim.diagnostic.severity.WARN] = diagnostic.message,
					[vim.diagnostic.severity.INFO] = diagnostic.message,
					[vim.diagnostic.severity.HINT] = diagnostic.message,
				}
				return diagnostic_message[diagnostic.severity]
			end,
		},
	})

	-- See `:help lspconfig-all` for a list of all the pre-configured LSPs
	local servers = {
		nixd = {
			settings = {
				nixpkgs = {
					expr = "import <nixpkgs> { }",
				},
				formatting = {
					command = { "nixfmt" },
				},
				options = {
					nixos = {
						expr = '(builtins.getFlake ("/home/lucas/nixconfig/")).nixosConfigurations.desktop.options',
					},
				},
			},
		},
		bashls = {
			filetypes = { "sh", "bash" },
		},
		clangd = {},
		elp = {},
		pyright = {},
		rubocop = {},
		ruby_lsp = {
			filetypes = { "ruby" },
		},
		rust_analyzer = {},
		postgres_lsp = {},
		lua_ls = {
			-- Treat the Neovim config dir (where `init.lua` lives) as the workspace
			-- root so lua_ls runs in workspace mode rather than single-file mode.
			-- In single-file mode, lazydev's runtime/library settings arrive via an
			-- async config pull that loses the race against the first diagnostic
			-- pass, so `vim` (and even `require`) flash as undefined on open.
			root_markers = { ".luarc.json", ".luarc.jsonc", ".git", "init.lua" },
			settings = {
				Lua = {
					completion = {
						callSnippet = "Replace",
					},
					-- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
					-- diagnostics = { disable = { 'missing-fields' } },
				},
			},
		},
	}

	local capabilities = require("blink.cmp").get_lsp_capabilities()
	for server, config in pairs(servers) do
		config.capabilities = vim.tbl_deep_extend("force", {}, capabilities, config.capabilities or {})
		vim.lsp.config(server, config)
		vim.lsp.enable(server)
	end
end

-- Helps managing Rust crates (showing/update version in Cargo.toml for example)
do
	vim.pack.add({
		{ src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1.*") },
		"https://github.com/saecki/crates.nvim",
	})

	require("crates").setup({
		lsp = {
			enabled = true,
			actions = true,
			completion = true,
			hover = true,
		},
	})
end

-- Provides neovim-specific completions.
do
	vim.pack.add({ "https://github.com/folke/lazydev.nvim" })
	require("lazydev").setup()
end
