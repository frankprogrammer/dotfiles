-- Pull in the wezterm API
local wezterm = require("wezterm")
local mux = wezterm.mux

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
-- config.color_scheme = "AdventureTime"
-- config.color_scheme = "Cloud (terminal.sexy)"
-- config.color_scheme = "Zenburn"
-- config.color_scheme = "GruvboxDark"
-- config.color_scheme = "Catppuccin Mocha"
-- config.color_scheme = "Catppuccin Macchiato"
-- config.color_scheme = "Monokai (dark) (terminal.sexy)"
config.color_scheme = "tokyonight"

config.front_end = "OpenGL"
config.max_fps = 165
config.default_cursor_style = "BlinkingBlock"
config.animation_fps = 1
config.cursor_blink_rate = 500
config.term = "xterm-256color" -- Set the terminal type
config.window_close_confirmation = "NeverPrompt"
config.window_background_opacity = 1.00
config.prefer_egl = true
config.font = wezterm.font_with_fallback({ { family = "Consolas" } }) --, { family = "0xProto Nerd Font" } })
config.font_size = 18.0

config.use_fancy_tab_bar = false
config.tab_max_width = 200

config.enable_kitty_keyboard = true

config.default_prog = { "powershell.exe", "-NoLogo" }

config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"

config.initial_cols = 100
config.initial_rows = 45

config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

config.keys = {
	{ key = "DownArrow", mods = "SHIFT|CTRL", action = wezterm.action.ActivateTabRelative(-1) },
	{ key = "UpArrow", mods = "SHIFT|CTRL", action = wezterm.action.ActivateTabRelative(1) },
	{ key = "LeftArrow", mods = "SHIFT|CTRL", action = wezterm.action.MoveTabRelative(-1) },
	{ key = "RightArrow", mods = "SHIFT|CTRL", action = wezterm.action.MoveTabRelative(1) },
	{ key = "Backspace", mods = "CTRL", action = wezterm.action.SendKey({ key = "w", mods = "CTRL" }) },
}

wezterm.on("gui-startup", function(cmd)
	local main_screen = wezterm.gui.screens().main
	local position = {
		x = -7,
		y = 0,
		width = main_screen.width / 2,
		height = main_screen.height,
		origin = "MainScreen",
	}

	cmd = cmd or {
		position = position,
		cwd = "D:\\ObsidianVault",
	}

	local _, first_pane, window = wezterm.mux.spawn_window(cmd)

	local _, second_pane, _ = window:spawn_tab({
		cwd = "D:\\ObsidianVault",
		-- cwd = "C:\\Users\\felro",
	})

	first_pane:send_text("nvim .\r")
	second_pane:send_text("nvim .\r")
	first_pane:activate()
end)

-- and finally, return the configuration to wezterm
return config
