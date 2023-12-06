local plugins = {
	'nvim-lua/plenary.nvim',
	'christoomey/vim-tmux-navigator',
	'tpope/vim-endwise',
	'stevearc/oil.nvim',
	{
		'ThePrimeagen/harpoon',
	},
	{
		'windwp/nvim-autopairs',
		event = "InsertEnter",
	},
	{
		'nvim-treesitter/nvim-treesitter',
		cmd = 'TSUpdate'
	},
	'neovim/nvim-lspconfig',
	'nvim-telescope/telescope.nvim'
}

require('lazy').setup(plugins)
