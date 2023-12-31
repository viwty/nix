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
    event = 'InsertEnter',
  },
  {
    'nvim-treesitter/nvim-treesitter',
    cmd = 'TSUpdate'
  },
  {
    'viwty/neocord',
    event = 'VeryLazy'
  },
  {
    'LhKipp/nvim-nu',
    cmd = 'TSInstall nu',
  },
  'neovim/nvim-lspconfig',
  'nvim-telescope/telescope.nvim',
  'ahmedkhalf/project.nvim',
  -- i hate this
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-buffer',
  'hrsh7th/cmp-path',
  'hrsh7th/cmp-cmdline',
  'hrsh7th/nvim-cmp',
  'L3MON4D3/LuaSnip',
  'saadparwaiz1/cmp_luasnip'
}

require('lazy').setup(plugins)
