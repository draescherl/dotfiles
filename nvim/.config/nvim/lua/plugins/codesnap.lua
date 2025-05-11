return {
	"mistricky/codesnap.nvim",
	build = "make",
	keys = {
		{ "<leader>ss", "<cmd>CodeSnapSave<cr>", mode = "x" },
	},
	opts = {
		bg_color = "#535c68",
		has_breadcrumbs = true,
		save_path = "~/Pictures",
		watermark = "",
	},
}
