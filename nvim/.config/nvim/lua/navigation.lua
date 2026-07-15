-- ============================================================
-- NAVIGATION.LUA
-- This file contains everything that makes moving around a
-- project easier. Think file explorer, fuzzy finder, ...
-- ============================================================

-- File explorer.
do
	vim.pack.add({ "https://github.com/nvim-mini/mini.files" })

	require("mini.files").setup({
		options = {
			use_as_default_explorer = true,
		},
		windows = {
			preview = true,
			width_focus = 25,
			width_preview = 80,
		},
	})
	vim.keymap.set("n", "<leader>F", MiniFiles.open)
	vim.keymap.set("n", "<leader>f", function() MiniFiles.open(vim.api.nvim_buf_get_name(0), false) end)
end

-- Fuzzy finder.
do
	vim.pack.add({
		"https://github.com/nvim-lua/plenary.nvim",
		"https://github.com/nvim-telescope/telescope-fzf-native.nvim",
		"https://github.com/nvim-telescope/telescope-ui-select.nvim",
		"https://github.com/nvim-tree/nvim-web-devicons",
		"https://github.com/debugloop/telescope-undo.nvim",
		"https://github.com/nvim-telescope/telescope.nvim",
	})

	-- Two important keymaps to use while in Telescope are:
	--  - Insert mode: <c-/>
	--  - Normal mode: ?
	--
	-- See `:help telescope` and `:help telescope.setup()`
	require("telescope").setup({
		-- `:help telescope.setup()`
		pickers = {
			find_files = {
				file_ignore_patterns = { "node_modules", ".git", "venv" },
				hidden = true,
			},
			live_grep = {
				file_ignore_patterns = { "node_modules", ".git", "venv" },
				additional_args = function(_)
					return { "--hidden" }
				end,
			},
		},
		extensions = {
			undo = {},
			["ui-select"] = {
				require("telescope.themes").get_dropdown(),
			},
		},
	})

	-- Make sure telescope-fzf-native is properly built so that the file picker
	-- behaves as expected (a space = AND, not empty set).
	do
		local fzf = vim.iter(vim.pack.get()):find(function(p)
			return p.spec.name == "telescope-fzf-native.nvim"
		end)
		if fzf and not vim.uv.fs_stat(fzf.path .. "/build/libfzf.so") and vim.fn.executable("make") == 1 then
			local r = vim.system({ "make" }, { cwd = fzf.path }):wait()
			if r.code ~= 0 then
				vim.notify("fzf-native build failed:\n" .. (r.stderr or ""), vim.log.levels.ERROR)
			end
		end
	end

	-- Enable Telescope extensions if they are installed
	pcall(require("telescope").load_extension, "fzf")
	pcall(require("telescope").load_extension, "ui-select")
	pcall(require("telescope").load_extension, "undo")

	vim.keymap.set("n", "<leader>u", "<cmd>Telescope undo<cr>")

	-- See `:help telescope.builtin`
	local builtin = require("telescope.builtin")
	vim.keymap.set("n", "<leader>sh", builtin.help_tags)
	vim.keymap.set("n", "<leader>sk", builtin.keymaps)
	vim.keymap.set("n", "<leader>sf", builtin.find_files)
	vim.keymap.set("n", "<leader>ss", builtin.builtin)
	vim.keymap.set("n", "<leader>sw", builtin.grep_string)
	vim.keymap.set("n", "<leader>sg", builtin.live_grep)
	vim.keymap.set("n", "<leader>sd", builtin.diagnostics)
	vim.keymap.set("n", "<leader>sr", builtin.resume)
	vim.keymap.set("n", "<leader>s.", builtin.oldfiles)
	vim.keymap.set("n", "<leader><leader>", builtin.buffers)

	vim.keymap.set("n", "<leader>/", function()
		builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
			winblend = 10,
			previewer = false,
		}))
	end)

	-- It's also possible to pass additional configuration options.
	--  See `:help telescope.builtin.live_grep()` for information about particular keys
	vim.keymap.set("n", "<leader>s/", function()
		builtin.live_grep({
			grep_open_files = true,
			prompt_title = "Live Grep in Open Files",
		})
	end)

	-- Shortcut for searching your Neovim configuration files
	vim.keymap.set("n", "<leader>sn", function()
		builtin.find_files({ cwd = vim.fn.stdpath("config") })
	end)
end

-- Harpoon.
do
	vim.pack.add({
		"https://github.com/nvim-lua/plenary.nvim",
		{ src = "https://github.com/ThePrimeagen/harpoon", version = "harpoon2" },
	})

	local harpoon = require("harpoon")
	harpoon:setup()

	vim.keymap.set("n", "<leader>a", function()
		harpoon:list():add()
	end)
	vim.keymap.set("n", "<leader>e", function()
		harpoon.ui:toggle_quick_menu(harpoon:list())
	end)

	vim.keymap.set("n", "<C-h>", function()
		harpoon:list():select(1)
	end)
	vim.keymap.set("n", "<C-j>", function()
		harpoon:list():select(2)
	end)
	vim.keymap.set("n", "<C-k>", function()
		harpoon:list():select(3)
	end)
	vim.keymap.set("n", "<C-l>", function()
		harpoon:list():select(4)
	end)

	-- Toggle previous & next buffers stored within Harpoon list
	vim.keymap.set("n", "<C-S-P>", function()
		harpoon:list():prev()
	end)
	vim.keymap.set("n", "<C-S-N>", function()
		harpoon:list():next()
	end)
end
