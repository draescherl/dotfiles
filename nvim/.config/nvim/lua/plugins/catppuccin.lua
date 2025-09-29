return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	lazy = false,
	config = function()
		vim.cmd.colorscheme("catppuccin-mocha")
		vim.cmd([[
		    highlight Normal guibg=none
		    highlight NonText guibg=none
		    highlight Normal ctermbg=none
		    highlight NonText ctermbg=none
		]])
	end,
}
