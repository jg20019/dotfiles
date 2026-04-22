local wezterm = require("wezterm")
local module = {}

local function project_dirs()
	local project_dir = wezterm.home_dir .. "/git"
	local projects = { wezterm.home_dir }
	for _, dir in ipairs(wezterm.glob(project_dir .. "/*")) do
		table.insert(projects, dir)
	end

	local lisp_project_dir = wezterm.home_dir .. "/quicklisp/local-projects/"
	for _, dir in ipairs(wezterm.glob(lisp_project_dir .. "/*")) do
		table.insert(projects, dir)
	end

	local personal_project_dir = wezterm.home_dir .. "/projects"
	for _, dir in ipairs(wezterm.glob(personal_project_dir .. "/*")) do
		table.insert(projects, dir)
	end

	-- Add the bin directory even though it isn't a project per se
	-- I use it to start bb repl for my bb scripts in Emacs
	table.insert(projects, "/home/jgibson/bin/")

	return projects
end

function module.choose_project()
	local choices = {}
	for _, value in ipairs(project_dirs()) do
		table.insert(choices, { label = value })
	end

	return wezterm.action.InputSelector({
		title = "Projects",

		-- The options we wish to choose from
		choices = choices,

		-- Yes we want to fuzzy search
		fuzzy = true,

		-- The action we want to perform. Note that this doesn't have to be
		-- a static definition as we've done before, but can be a callback that
		-- evaluates any arbitrary code
		action = wezterm.action_callback(function(child_window, child_pane, id, label)
			-- If we don't select anything label is empty so we return
			if not label then
				return
			end

			child_window:perform_action(
				wezterm.action.SwitchToWorkspace({
					name = label:match("([^/]+)$"),
					spawn = { cwd = label },
				}),
				child_pane
			)
		end),
	})
end

return module
