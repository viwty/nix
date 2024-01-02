vim.loader.enable()

local path = vim.fn.stdpath 'data' .. '/lazy/'
local lazypath = path .. 'lazy.nvim/'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local function install(user, repo)
  local path = ("%s/%s"):format(path, repo)
  if not vim.loop.fs_stat(path) then
    vim.fn.system { 'git', 'clone', ('https://github.com/%s/%s'):format(user, repo), path .. repo }
    vim.fn.nvim_command('packadd ' .. repo)
  end
end

require 'opts'
require 'plugins'
require 'autocmds'

-- sourced after loading plugins because of lazy
vim.cmd 'source ~/.config/nvim/colors.vim'

local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  callback = function()
    local env = getfenv(vim.lsp.buf.format)
    env.vim.notify = function() end
    setfenv(vim.lsp.buf.format, env)
    vim.lsp.buf.format { async = false }
  end,
})
