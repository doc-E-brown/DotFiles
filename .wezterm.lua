local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.window_decorations = "NONE"
config.window_background_opacity = 0.9
config.window_padding = {
	left = "0.5cell",
	right = "0.5cell",
	top = "0cell",
	bottom = "0cell",
}
config.color_scheme = "Red Planet"

return config
