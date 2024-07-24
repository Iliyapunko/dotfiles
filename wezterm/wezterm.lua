local wezterm = require 'wezterm'
local Config = require 'lua/Config'
local fonts = require 'lua/fonts'
local theme = require 'lua/themes/rose_pine_light'

local config = Config:new()

config:add(fonts.build_font(fonts.configs.fira))

config:add(theme)

config:add {
	-- front_end = 'OpenGL',
	-- freetype_load_target = 'HorizontalLcd',
	enable_tab_bar = false,
	enable_scroll_bar = false,
	scrollback_lines = 1000,
	max_fps = 240,
	animation_fps = 240,
	cursor_blink_rate = 0,
	default_cursor_style = 'SteadyBlock',
	disable_default_key_bindings = true,
	warn_about_missing_glyphs = false,
	window_close_confirmation = 'NeverPrompt',
}

config:set_window_paddings {
	left = 20,
	right = 20,
	top = 15,
	bottom = 1,
}

config:set_mouse_bindings {
	{
		event = { Up = { streak = 1, button = 'Left' } },
		mods = 'CTRL',
		action = wezterm.action.OpenLinkAtMouseCursor,
	},
}

config:set_keys {
	{ key = 'V', mods = 'CTRL', action = wezterm.action.PasteFrom 'Clipboard' },
	{ key = 'v', mods = 'SUPER', action = wezterm.action.PasteFrom 'Clipboard' },
	{ key = '=', mods = 'CTRL', action = wezterm.action.IncreaseFontSize },
	{ key = '0', mods = 'CTRL', action = wezterm.action.ResetFontSize },
	{ key = '-', mods = 'CTRL', action = wezterm.action.DecreaseFontSize },
	{ key = 'q', mods = 'CMD', action = wezterm.action.QuitApplication },
}

wezterm.on('gui-startup', function(cmd)
	local _, _, window = wezterm.mux.spawn_window(cmd or {})
	window:gui_window():toggle_fullscreen() -- toggle_fullscreen or maximize
end)

return config:to_wezterm_config()
