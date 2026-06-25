-- ============================================================
-- SECTION 1: OPTIONS
-- ============================================================
do
	-- Cache compiled lua modules for faster startup.
	vim.loader.enable()

	vim.g.mapleader = " "
	vim.g.maplocalleader = " "

	vim.o.number = true
	vim.o.relativenumber = true

	vim.o.list = true
	vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

	vim.o.inccommand = "split"
	vim.o.ignorecase = true
	vim.o.smartcase = true

	-- Schedule start after `UiEnter` because it can increase startup-time.
	vim.schedule(function()
		vim.o.clipboard = "unnamedplus"
	end)

	-- Increase frequency at which swap file is flushed to disk.
	vim.o.updatetime = 250

	vim.o.splitright = true
	vim.o.splitbelow = true

	-- Use only spaces and tabs are 4 spaces.
	vim.o.shiftwidth = 4
	vim.o.softtabstop = -1
	vim.o.expandtab = true

	vim.o.shm = "S"
	vim.opt_global.shortmess:remove("F")

	vim.o.conceallevel = 0
	vim.o.showmode = false
	vim.o.undofile = true
	vim.o.signcolumn = "yes"
	vim.o.mouse = "a"
	vim.o.cursorline = true
	vim.o.scrolloff = 15
end

-- ============================================================
-- SECTION 2: KEYMAPS
-- ============================================================
do
	local keymap_opts = { noremap = true, remap = false, silent = true }

	vim.keymap.set("n", "<leader>nr", vim.cmd.Ex, keymap_opts)
	vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", keymap_opts)
	vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", keymap_opts)

	-- Delete single character without copying into register.
	vim.keymap.set("n", "x", '"_x', keymap_opts)

	-- Center target line vertically when moving up/down.
	vim.keymap.set("n", "<C-d>", "<C-d>zz", keymap_opts)
	vim.keymap.set("n", "<C-u>", "<C-u>zz", keymap_opts)

	-- Center target line vertically when searching.
	vim.keymap.set("n", "n", "nzzzv", keymap_opts)
	vim.keymap.set("n", "N", "Nzzzv", keymap_opts)

	-- Resize with arrows.
	vim.keymap.set("n", "<Up>", ":resize -2<CR>", keymap_opts)
	vim.keymap.set("n", "<Down>", ":resize +2<CR>", keymap_opts)
	vim.keymap.set("n", "<Left>", ":vertical resize -2<CR>", keymap_opts)
	vim.keymap.set("n", "<Right>", ":vertical resize +2<CR>", keymap_opts)

	-- Window management.
	vim.keymap.set("n", "<leader>v", "<C-w>v", keymap_opts) -- split window vertically
	vim.keymap.set("n", "<leader>b", "<C-w>s", keymap_opts) -- split window horizontally
	vim.keymap.set("n", "<leader>se", "<C-w>=", keymap_opts) -- make split windows equal width & height
	vim.keymap.set("n", "<leader>xs", ":close<CR>", keymap_opts) -- close current split window

	-- Tabs.
	vim.keymap.set("n", "<leader>to", ":tabnew<CR>", keymap_opts) -- open new tab
	vim.keymap.set("n", "<leader>tx", ":tabclose<CR>", keymap_opts) -- close current tab
	vim.keymap.set("n", "<leader>tn", ":tabn<CR>", keymap_opts) --  go to next tab
	vim.keymap.set("n", "<leader>tp", ":tabp<CR>", keymap_opts) --  go to previous tab

	-- Stay in indent mode.
	vim.keymap.set("v", "<", "<gv", keymap_opts)
	vim.keymap.set("v", ">", ">gv", keymap_opts)

	-- Keep last yanked when pasting.
	vim.keymap.set("v", "p", '"_dP', keymap_opts)

	-- Diagnostic Config & Keymaps
	--  See `:help vim.diagnostic.Opts`
	vim.diagnostic.config({
		update_in_insert = false,
		severity_sort = true,
		float = { border = "rounded", source = "if_many" },
		underline = { severity = { min = vim.diagnostic.severity.WARN } },
		virtual_text = true, -- Text shows up at the end of the line

		-- Auto open the float, so you can easily read the errors when jumping with `[d` and `]d`
		jump = {
			on_jump = function(_, bufnr)
				vim.diagnostic.open_float({
					bufnr = bufnr,
					scope = "cursor",
					focus = false,
				})
			end,
		},
	})
	vim.keymap.set("n", "<leader>dp", vim.diagnostic.get_prev)
	vim.keymap.set("n", "<leader>dn", vim.diagnostic.get_next)
	vim.keymap.set("n", "<leader>ds", vim.diagnostic.open_float)
	vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist)

	-- Highlight on yank.
	vim.api.nvim_create_autocmd("TextYankPost", {
		-- The group exists to dedup the autocmd on config reload.
		group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
		callback = function()
			vim.hl.on_yank()
		end,
	})
end

-- ============================================================
-- SECTION 3: PLUGINS
-- ============================================================
do
	vim.api.nvim_create_user_command("PackUpdate", function()
		vim.pack.update(nil, { force = true })
	end, {})

	local function run_build(name, cmd, cwd)
		local result = vim.system(cmd, { cwd = cwd }):wait()
		if result.code ~= 0 then
			local stderr = result.stderr or ""
			local stdout = result.stdout or ""
			local output = stderr ~= "" and stderr or stdout
			if output == "" then
				output = "No output from build command."
			end
			vim.notify(("Build failed for %s:\n%s"):format(name, output), vim.log.levels.ERROR)
		end
	end

	-- If a plugin requires a specific build step, add it here.
	vim.api.nvim_create_autocmd("PackChanged", {
		callback = function(ev)
			local name, kind = ev.data.spec.name, ev.data.kind
			-- Hook to update parsers when nvim-treesitter updates.
			-- It is recommended to register the autocommand before the first call to vim.pack.add(). See:
			-- https://echasnovski.com/blog/2026-03-13-a-guide-to-vim-pack#hooks
			if name == "nvim-treesitter" and kind == "update" then
				if not ev.data.active then
					vim.cmd.packadd("nvim-treesitter")
				end
				vim.cmd("TSUpdate")
			end

			if name == "telescope-fzf-native.nvim" and vim.fn.executable("make") == 1 then
				run_build(name, { "make" }, ev.data.path)
				return
			end
		end,
	})

	require("coding")
	require("navigation")
	require("ui")
end
