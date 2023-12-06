require'oil'.setup{
	show_hidden = true,
	in_always_hidden = function(name, bufnr) return false end
}

vim.keymap.set('n', '-', '<CMD>Oil<CR>')
