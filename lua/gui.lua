vim.opt.guifont = "Iosevka Nerd Font Mono:h14, Iosevka NFM:h12"
-- vim.opt.linespace = 0 -- Controls spacing between lines, may also be negative.

if vim.g.neovide then
  --
  -- ### function to change scale factor with keybindings
  vim.g.neovide_scale_factor = 1.0
  local change_scale_factor = function(delta)
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
  end
  vim.keymap.set("n", "<C-=>", function()
    change_scale_factor(1.1)
  end)
  vim.keymap.set("n", "<C-->", function()
    change_scale_factor(1 / 1.1)
  end)

  -- ### Controls the space between the window border and the actual Neovim, which is filled with the background color instead.
  -- vim.g.neovide_padding_top = 0
  -- vim.g.neovide_padding_bottom = 0
  -- vim.g.neovide_padding_right = 0
  -- vim.g.neovide_padding_left = 0

  -- ### transparency
  -- local alpha = function()
  --   return string.format("%x", math.floor(255 * vim.g.transparency or 0.8))
  -- end
  -- ### note that g:neovide_transparency should be 0 if you want to unify transparency of content and title bar.
  -- ### Setting g:neovide_transparency to a value between 0.0 and 1.0 will set the opacity of the window to that value.
  vim.g.neovide_transparency = 0.0
  vim.g.transparency = 1
  -- ### Setting g:neovide_background_color to a value that can be parsed by csscolorparser-rs will set the color of the whole window to that value.
  -- vim.g.neovide_background_color = "#000000" .. alpha()
  vim.g.neovide_background_color = "#000000"

  -- ### blur
  -- vim.g.neovide_floating_blur_amount_x = 2.0
  -- vim.g.neovide_floating_blur_amount_y = 2.0

  -- ### scroll
  -- vim.g.neovide_scroll_animation_length = 0.3

  -- ### general
  --Set the background option when Neovide starts. Possible values: light, dark, auto. On systems that support it, auto will mirror the system theme, and will update background when the system theme changes.
  -- vim.g.neovide_theme = "dark" -- light, dark, auto
  -- vim.g.neovide_fullscreen = true
  vim.g.neovide_remember_window_size = true
  -- ### Interprets Alt + whatever actually as <M-whatever>, instead of sending the actual special character to Neovim.
  -- vim.g.neovide_input_macos_alt_is_meta = false
  -- ### Setting g:neovide_cursor_animation_length determines the time it takes for the cursor to complete it's animation in seconds. Set to 0 to disable.

  -- ### cursor
  -- vim.g.neovide_cursor_animation_length = 0.13
  vim.g.neovide_cursor_trail_size = 0.2
  -- vim.g.neovide_cursor_antialiasing = true
  -- vim.g.neovide_cursor_animate_in_insert_mode = true
  -- vim.g.neovide_cursor_animate_command_line = true
  -- ### Specify cursor outline width in ems. You probably want this to be a positive value less than 0.5. If the value is <=0 then the cursor will be invisible. This setting takes effect when the editor window is unfocused, at which time a block cursor will be rendered as an outline instead of as a full rectangle.
  -- vim.g.neovide_cursor_unfocused_outline_width = 0.125
end
