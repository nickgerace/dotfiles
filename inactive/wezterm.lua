local wezterm = require 'wezterm'

local config = {}
if wezterm.config_builder then
    config = wezterm.config_builder()
end

config.font = wezterm.font 'Iosevka Nerd Font'
config.enable_tab_bar = false
config.color_scheme = 'OneHalfLight'
config.audible_bell = 'Disabled'

config.font_size = 12
if wezterm.target_triple == 'aarch64-apple-darwin' then
    config.font_size = 16
end

return config
