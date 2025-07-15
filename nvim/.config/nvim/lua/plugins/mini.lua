return {
	"echasnovski/mini.nvim",
	version = false,
	config = function()
		-- require("mini.pairs").setup()
		require("mini.icons").setup()
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

		vim.keymap.set("n", "<leader>f", MiniFiles.open)
	end,
}
