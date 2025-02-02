local wezterm = require("wezterm")
local module = {}

local fd = "/usr/bin/fd"
function module.sessionize()
	local choices = {}
	local home = os.getenv("HOME")
	local success, stdout, stderr = wezterm.run_child_process({
		fd,
		".",
		home .. "/dotfiles",
		home .. "/Documents/pro",
		home .. "/Documents/perso",
		home .. "/Documents/oss",
		"--min-depth",
		"1",
		"--max-depth",
		"1",
		"--type",
		"d",
	})

	if not success then
		wezterm.log_error("Failed to run fd: " .. stderr)
		return
	end

	stdout = home .. "/dotfiles/\n" .. stdout
	for directory in stdout:gmatch("[^\n]+") do
		local session_name = directory:match("([^/]+)/$")
		table.insert(choices, { id = session_name, label = directory })
	end

	return wezterm.action.InputSelector({
		title = "Sessionizer",
		choices = choices,
		fuzzy = true,
		action = wezterm.action_callback(function(window, pane, session_name, directory)
			if not directory then
				wezterm.log_info("Cancelled")
				return
			end

			wezterm.GLOBAL.previous_workspace = window:active_workspace()
			local msg = string.format(
				"Creating session [%s] in directory [%s]. Previous workspace is now [%s].",
				session_name,
				directory,
				wezterm.GLOBAL.previous_workspace
			)
			wezterm.log_info(msg)
			window:perform_action(
				wezterm.action.SwitchToWorkspace({
					name = session_name,
					spawn = { cwd = directory },
				}),
				pane
			)
		end),
	})
end

return module
