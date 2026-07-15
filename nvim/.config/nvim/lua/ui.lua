-- ============================================================
-- UI.LUA
-- This file contains everything that changes how the nvim UI
-- looks. Think colours, git signs, TODO comments, lines, ...
-- ============================================================

-- Colours.
do
	vim.pack.add({
		"https://github.com/sainnhe/everforest",
		"https://github.com/morhetz/gruvbox",
	})

	vim.g.everforest_enable_italic = true
	vim.cmd.colorscheme("everforest")
end

-- Icons.
do
	vim.pack.add({ "https://github.com/nvim-mini/mini.icons" })
	require("mini.icons").setup()
end

-- Status line.
do
	vim.pack.add({
		"https://github.com/nvim-tree/nvim-web-devicons",
		"https://github.com/nvim-lualine/lualine.nvim",
	})

	require("lualine").setup({
		options = {
			icons_enabled = true,
			theme = "auto",
			component_separators = { left = "", right = "" },
			section_separators = { left = "", right = "" },
			disabled_filetypes = {
				statusline = {},
				winbar = {},
			},
			ignore_focus = {},
			always_divide_middle = true,
			always_show_tabline = true,
			globalstatus = false,
			refresh = {
				statusline = 100,
				tabline = 100,
				winbar = 100,
			},
		},
		sections = {
			lualine_a = { "mode" },
			lualine_b = { "branch", "diff", "diagnostics" },
			lualine_c = {
				{
					"filename",
					path = 1,
				},
			},
			lualine_x = { "searchcount", "encoding", "fileformat", "filetype" },
			lualine_y = { "progress" },
			lualine_z = { "location" },
		},
		inactive_sections = {
			lualine_a = {},
			lualine_b = {},
			lualine_c = { "filename" },
			lualine_x = { "location" },
			lualine_y = {},
			lualine_z = {},
		},
		tabline = {},
		winbar = {},
		inactive_winbar = {},
		extensions = {},
	})
end

-- Git signs.
do
	vim.pack.add({ "https://github.com/lewis6991/gitsigns.nvim" })

	require("gitsigns").setup({
		signs = {
			add = { text = "+" },
			change = { text = "~" },
			delete = { text = "_" },
			topdelete = { text = "‾" },
			changedelete = { text = "~" },
		},
	})
end

-- Markdown viewer.
do
	vim.pack.add({
		"https://github.com/saghen/blink.cmp",
		"https://github.com/OXY2DEV/markview.nvim",
	})

	-- Don't render on open, only when toggled via the keybind below.
	require("markview").setup({
		preview = {
			enable = false,
		},
	})

	vim.keymap.set("n", "<leader>mv", "<cmd>Markview toggle<cr>")
end

-- TODO comments.
do
	vim.pack.add({
		"https://github.com/nvim-lua/plenary.nvim",
		"https://github.com/folke/todo-comments.nvim",
	})

	require("todo-comments").setup({
		signs = false,
	})
end
