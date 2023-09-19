-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt
local g = vim.g
local o = vim.o

opt.clipboard = ""
opt.shiftwidth = 4
opt.tabstop = 4

g.tex_flavor = "latex"
-- g.vimtex_view_method = "zathura"
g.vimtex_quickfix_mode = 0
g.tex_conceal = "abdmg"
g.vimtex_fold_enabled = 1

if g.neovide then
  o.guifont = "Caskaydia Cove Nerd,Noto Color Emoji:h10"
  g.neovide_hide_mouse_when_typing = true
  g.neovide_theme = "auto"
  g.neovide_confirm_quit = true
  g.neovide_cursor_animate_in_insert_mode = true
  g.neovide_cursor_animate_command_line = true
end
