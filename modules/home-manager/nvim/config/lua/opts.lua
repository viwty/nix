vim.g.mapleader = ' '
vim.o.number = true
vim.o.relativenumber = true
vim.o.clipboard = 'unnamedplus'
vim.o.breakindent = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.termguicolors = true
vim.o.completeopt = 'menuone,noselect'

vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.colorcolumn = "80"

vim.o.smartindent = true
vim.o.wrap = true
vim.o.linebreak = true
vim.o.swapfile = false
vim.o.backup = false

vim.o.scrolloff = "7"
vim.o.clipboard = "unnamedplus"

vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.keymap.set('n', 'k', 'gk', { silent = true })
vim.keymap.set('n', 'j', 'gj', { silent = true })

vim.keymap.set('n', '<leader>u', function()
  local file = vim.api.nvim_buf_get_name(0)
  vim.fn.system { 'paste', file }
end)

vim.keymap.set('n', '<C-w>h', ':split<CR>')
