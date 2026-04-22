local wezterm = require("wezterm")
local projects = require("projects")

local config = wezterm.config_builder()

config.color_scheme = "tokyonight"
config.font_size = 13
config.debug_key_events = true

-- Slightly transparent and blurred background
config.window_background_opacity = 0.9
config.macos_window_background_blur = 30

-- Removes title bar
config.window_decorations = "RESIZE"
config.window_frame = {
	font_size = 11,
}

config.window_close_confirmation = "AlwaysPrompt"

local function segments_for_right_status(window)
	return {
		window:active_workspace(),
		wezterm.strftime("%a %b %-d %H:%M"),
		wezterm.hostname(),
	}
end

config.hyperlink_rules = wezterm.default_hyperlink_rules()

-- Make Jira tickets clickable
-- Clicking anything formatted like a Jira ticket number will
-- Open that ticket in the browser
table.insert(config.hyperlink_rules, {
	regex = [[\b([A-Z]+-\d+)[-_a-zA-Z0-9]*\b]],
	format = "https://treeoflifebooks.atlassian.net/browse/$1",
})

wezterm.on("open-uri", function(window, pane, uri)
	local start, match_end = uri:find("mailto:")
	if start == 1 then
		-- prevent the default action from opening in a browser
		return false
	end
end)

-- Keyboard Configuration
-- Makes Ctrl + a into the leader key
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1200 }

local function move_pane(key, direction)
	return {
		key = key,
		mods = "LEADER",
		action = wezterm.action.ActivatePaneDirection(direction),
	}
end

local function resize_pane(key, direction)
	return {
		key = key,
		action = wezterm.action.AdjustPaneSize({ direction, 3 }),
	}
end

config.keys = {
	{
		key = '"',
		mods = "LEADER|SHIFT",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "%",
		mods = "LEADER|SHIFT",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "a",
		-- When we're in leader mode _and_ CTRL + A is pressed...
		mods = "LEADER|CTRL",
		-- Actually send CTRL + A key to the terminal
		action = wezterm.action.SendKey({ key = "a", mods = "CTRL" }),
	},
	move_pane("j", "Down"),
	move_pane("k", "Up"),
	move_pane("h", "Left"),
	move_pane("l", "Right"),
	{
		-- When we push LEADER + R...
		key = "r",
		mods = "LEADER",
		-- Activate the `resize_panes` keytable
		action = wezterm.action.ActivateKeyTable({
			name = "resize_panes",
			-- Ensures the keytable stays active after it handles its
			-- first keypress.
			one_shot = false,
			-- Deactivate the keytable after a timeout.
			timeout_milliseconds = 1000,
		}),
	},
	{
		key = "p",
		mods = "LEADER",
		action = projects.choose_project(),
	},
	{
		key = "f",
		mods = "LEADER",
		action = wezterm.action.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }),
	},
	{
		key = "RightArrow",
		mods = "LEADER",
		action = wezterm.action.RotatePanes("Clockwise"),
	},
	{
		key = "LeftArrow",
		mods = "LEADER",
		action = wezterm.action.RotatePanes("CounterClockwise"),
	},
	{
		key = "0",
		mods = "CTRL",
		action = wezterm.action.DisableDefaultAssignment,
	},
	{
		key = "0",
		mods = "SHIFT|CTRL",
		action = wezterm.action.DisableDefaultAssignment,
	},
	{
		key = ")",
		mods = "SHIFT|CTRL",
		action = wezterm.action.DisableDefaultAssignment,
	},
	{
		key = "Enter",
		mods = "ALT",
		action = wezterm.action.DisableDefaultAssignment,
	},
}

config.key_tables = {
	resize_panes = {
		resize_pane("j", "Down"),
		resize_pane("k", "Up"),
		resize_pane("h", "Left"),
		resize_pane("l", "Right"),
	},
}

return config
