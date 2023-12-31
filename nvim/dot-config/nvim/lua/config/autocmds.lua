-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local TheM2Group = augroup("M2", { clear = true })
local yank_group = augroup("YankGroup", { clear = true })
local wrap_group = augroup("WrapGroup", { clear = true })

function Copy()
  if vim.v.event.operator == "y" and vim.v.event.regname == "+" and not vim.g.neovide then
    require("osc52").copy_register("+")
  end
end

autocmd("TextYankPost", {
  group = yank_group,
  pattern = "*",
  callback = Copy,
})

autocmd({ "VimEnter", "VimResume" }, {
  group = TheM2Group,
  pattern = "*",
  command = "set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175",
})

autocmd({ "VimLeave", "VimSuspend" }, {
  group = TheM2Group,
  pattern = "*",
  command = "set guicursor=a:block-blinkwait175-blinkoff150-blinkon175",
})

autocmd("InsertEnter", {
  group = TheM2Group,
  pattern = "*",
  command = "norm zz",
})

autocmd("FileType", {
  group = wrap_group,
  pattern = { "gitcommit", "markdown", "latex", "tex" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})
