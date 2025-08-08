return { -- Autoformat
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			"<leader>ri",
			function()
				require("conform").format({ async = true, lsp_format = "fallback" })
			end,
			mode = "",
		},
	},
	opts = {
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
	},
}
