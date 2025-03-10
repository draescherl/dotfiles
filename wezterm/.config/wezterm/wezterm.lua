local wezterm = require("wezterm")
local sessionizer = require("sessionizer")
local config = wezterm.config_builder()

config.adjust_window_size_when_changing_font_size = false
config.color_scheme = "Catppuccin Mocha"
config.font = wezterm.font("JetBrainsMono Nerd Font", { weight = "Bold" })
config.font_size = 13.0
config.window_decorations = "NONE"
config.window_background_opacity = 0.9
config.unzoom_on_switch_pane = false
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.bypass_mouse_reporting_modifiers = "SHIFT"
config.disable_default_key_bindings = true
config.default_cursor_style = "SteadyBar"
config.window_padding = {
	left = 0,
	top = 0,
	right = 0,
	bottom = 0,
}
config.scrollback_lines = 100000
config.enable_scroll_bar = true

local function activate_tab(key, index)
	return {
		key = key,
		mods = "ALT",
		action = wezterm.action.ActivateTab(index),
	}
end

local function change_focus(key, direction)
	return {
		key = key,
		mods = "ALT",
		action = wezterm.action.ActivatePaneDirection(direction),
	}
end

local function resize_pane(key, direction)
	return {
		key = key,
		mods = "SHIFT|ALT",
		action = wezterm.action.AdjustPaneSize({ direction, 2 }),
	}
end

local function rename_tab()
	return wezterm.action.PromptInputLine({
		description = "Rename tab",
		action = wezterm.action_callback(function(window, _, line)
			if line then
				window:active_tab():set_title(line)
			end
		end),
	})
end

config.keys = {
	-- tabs
	{ key = "t", mods = "ALT", action = wezterm.action.SpawnTab("CurrentPaneDomain") },
	activate_tab("&", 0),
	activate_tab("2", 1),
	activate_tab('"', 2),
	activate_tab("'", 3),
	activate_tab("(", 4),
	activate_tab("-", 5),
	activate_tab("7", 6),
	activate_tab("_", 7),
	activate_tab("9", 8),
	activate_tab("0", 9),
	{ key = "r", mods = "ALT", action = rename_tab() },

	-- panes
	{ key = "n", mods = "ALT", action = wezterm.action.SplitPane({ direction = "Right", size = { Percent = 50 } }) },
	{ key = "b", mods = "ALT", action = wezterm.action.SplitPane({ direction = "Down", size = { Percent = 50 } }) },
	{ key = "z", mods = "ALT", action = wezterm.action.TogglePaneZoomState },
	{ key = "x", mods = "ALT", action = wezterm.action.CloseCurrentPane({ confirm = true }) },
	change_focus("h", "Left"),
	change_focus("j", "Down"),
	change_focus("k", "Up"),
	change_focus("l", "Right"),
	resize_pane("h", "Left"),
	resize_pane("j", "Down"),
	resize_pane("k", "Up"),
	resize_pane("l", "Right"),

	-- other stuff
	{ key = "C", mods = "CTRL", action = wezterm.action.CopyTo("Clipboard") },
	{ key = "V", mods = "CTRL", action = wezterm.action.PasteFrom("Clipboard") },
	{ key = ")", mods = "ALT", action = wezterm.action.DecreaseFontSize },
	{ key = "=", mods = "ALT", action = wezterm.action.IncreaseFontSize },
	{ key = "=", mods = "CTRL", action = wezterm.action.ResetFontSize },
	{ key = "q", mods = "ALT", action = wezterm.action.QuitApplication },
	{ key = "O", mods = "ALT", action = wezterm.action.ShowDebugOverlay },
	{ key = "f", mods = "ALT", action = sessionizer.sessionize() },
	{ key = "p", mods = "ALT", action = wezterm.action.ActivateCommandPalette },
	{ key = "w", mods = "ALT", action = wezterm.action.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }) },
	{ key = "U", mods = "ALT", action = wezterm.action.ScrollByPage(-1) },
	{ key = "u", mods = "ALT", action = wezterm.action.ScrollByLine(-1) },
	{ key = "D", mods = "ALT", action = wezterm.action.ScrollByPage(1) },
	{ key = "d", mods = "ALT", action = wezterm.action.ScrollByLine(1) },
}

wezterm.on("update-status", function(window)
	local color_scheme = window:effective_config().resolved_palette
	local bg = color_scheme.brights[3]
	local fg = color_scheme.background

	window:set_left_status(wezterm.format({
		{ Background = { Color = bg } },
		{ Foreground = { Color = fg } },
		{ Text = " " .. window:active_workspace() .. " " },
	}))
end)

return config
