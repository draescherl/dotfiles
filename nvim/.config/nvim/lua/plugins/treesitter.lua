return { -- Highlight, edit, and navigate code
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		local ts = require("nvim-treesitter")

		-- Parsers to keep installed.
		ts.install({
			"bash",
			"c",
			"diff",
			"html",
			"lua",
			"luadoc",
			"markdown",
			"markdown_inline",
			"query",
			"vim",
			"vimdoc",
			"rust",
			"scala",
		})

		-- Set of all upstream-available parsers. Cached once because
		-- `get_available` fires the `User TSUpdate` autocmd on every call.
		local available = {}
		for _, lang in ipairs(ts.get_available()) do
			available[lang] = true
		end

		-- On the `main` branch, highlighting and indentation are enabled
		-- per-buffer by Neovim itself, not by this plugin. Enable them on every
		-- filetype that has a parser, auto-installing it on first use (replaces
		-- the old `auto_install`).
		vim.api.nvim_create_autocmd("FileType", {
			callback = function(args)
				local buf = args.buf
				local lang = vim.treesitter.language.get_lang(args.match)
				if not lang or not available[lang] then
					return -- unknown filetype or no parser upstream
				end

				local function enable()
					if not vim.api.nvim_buf_is_valid(buf) then
						return
					end
					vim.treesitter.start(buf, lang)
					-- treesitter-based indentation (experimental upstream)
					vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end

				if vim.list_contains(ts.get_installed("parsers"), lang) then
					enable()
				else
					-- compile asynchronously, then enable once it lands
					ts.install({ lang }):await(function(err)
						if not err then
							vim.schedule(enable)
						end
					end)
				end
			end,
		})
	end,
}
