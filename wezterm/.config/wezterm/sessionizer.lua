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
		action = wezterm.action_callback(function(child_window, child_pane, id, label)
			if not label then
				wezterm.log_info("Cancelled")
				return
			end

			local msg = string.format("Creating session [%s] in directory [%s]", id, label)
			wezterm.log_info(msg)
			child_window:perform_action(
				wezterm.action.SwitchToWorkspace({
					name = id,
					spawn = { cwd = label },
				}),
				child_pane
			)
		end),
	})
end

return module
