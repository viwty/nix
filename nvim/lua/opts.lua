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

vim.cmd("set cb=unnamedplus")
vim.cmd("set so=20")

vim.keymap.set({'n', 'v'}, '<Space>', '<Nop>', { silent = true})
vim.keymap.set('n', 'k', 'gk', {silent = true})
vim.keymap.set('n', 'j', 'gj', {silent = true})

vim.keymap.set('n', '<C-w>h', ':split<CR>')
