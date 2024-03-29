local wezterm = require 'wezterm'

local config = {}
if wezterm.config_builder then
    config = wezterm.config_builder()
end

config.font = wezterm.font 'Iosevka Nerd Font'
config.font_size = 16
config.enable_tab_bar = false
config.color_scheme = 'OneHalfLight'

return config
