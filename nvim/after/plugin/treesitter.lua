require'nvim-treesitter.configs'.setup {
	ensure_installed = {"rust", "lua", "ruby", "nix"},
	auto_install = true,
	highlight = { enable = true },
	indent = { enable = true },
}
