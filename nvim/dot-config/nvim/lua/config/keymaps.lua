-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "Y", "y$", { noremap = true, silent = true, desc = "Copy to EOL" })
vim.keymap.set("n", "<leader>y", "\"+y", { noremap = true, silent = true, desc = "Copy to +R" })
vim.keymap.set("v", "<leader>y", "\"+y", { noremap = true, silent = true, desc = "Copy to +R" })
vim.keymap.set("v", "<leader>Y", "\"+y$", { noremap = true, silent = true, desc = "Copy to +R to EOL" })
