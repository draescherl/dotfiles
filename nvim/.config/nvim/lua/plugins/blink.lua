return { -- Autocompletion
	"saghen/blink.cmp",
	event = "VimEnter",
	version = "1.*",
	dependencies = {
		"folke/lazydev.nvim",
	},
	--- @module 'blink.cmp'
	--- @type blink.cmp.Config
	opts = {
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
			per_filetype = {
				sql = { "dadbod" },
			},
			default = { "lsp", "path", "snippets", "lazydev", "buffer" },
			providers = {
				dadbod = { module = "vim_dadbod_completion.blink" },
				lazydev = { module = "lazydev.integrations.blink", score_offset = 100 },
			},
		},
		fuzzy = { implementation = "lua" },
		signature = { enabled = true },
	},
}
