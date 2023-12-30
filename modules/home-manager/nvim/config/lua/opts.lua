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

vim.g.neovide_transparency = 0.8
vim.g.neovide_hide_mouse_when_typing = true
vim.g.neovide_remember_window_size = false
vim.g.neovide_cursor_vfx_mode = "pixiedust"
vim.g.neovide_cursor_vfx_particle_density = 30

vim.cmd("set cb=unnamedplus")
vim.cmd("set so=20")

vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.keymap.set('n', 'k', 'gk', { silent = true })
vim.keymap.set('n', 'j', 'gj', { silent = true })

vim.keymap.set('n', '<leader>u', function()
  local file = vim.api.nvim_buf_get_name(0)
  vim.fn.system { 'paste', file }
end)

vim.keymap.set('n', '<C-w>h', ':split<CR>')
