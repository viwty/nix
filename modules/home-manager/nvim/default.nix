{ config, lib, pkgs, nix-colors, buildVimPluginFrom2Nix, ... }:

let inherit (nix-colors.lib-contrib { inherit pkgs; }) vimThemeFromScheme;
in {
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      {
        plugin = packer-nvim;
        type = "lua";
        config = ''
          require"packer".startup(function(use)
          use "pigpigyyy/Yuescript-vim"
          use "xiyaowong/transparent.nvim"
          use "viwty/presence.nvim"
          use "thePrimeagen/harpoon"

          use {
            "VonHeikemen/lsp-zero.nvim",
            branch = "v1.x",
            requires = {
              { "neovim/nvim-lspconfig" },

              { "hrsh7th/nvim-cmp" },
              { "hrsh7th/cmp-nvim-lsp" },
              { "hrsh7th/cmp-buffer" },
              { "hrsh7th/cmp-path" },
              { "saadparwaiz1/cmp_luasnip" },
              { "hrsh7th/cmp-nvim-lua" },

              { "L3MON4D3/LuaSnip" },
              { "rafamadriz/friendly-snippets" },
            }
          }
          end)
        '';
      }
      vim-numbertoggle
      vim-tmux-navigator
      nvim-web-devicons
      plenary-nvim
      auto-pairs
      vim-endwise
      {
        plugin = oil-nvim;
        type = "lua";
        config = ''
          require("oil").setup({
            default_file_explorer = true,
          })

          vim.keymap.set("n", "-", "<CMD>Oil<CR>")
        '';
      }
      {
        plugin = vimThemeFromScheme { scheme = config.colorScheme; };
        config = ''
          colorscheme nix-${config.colorScheme.slug}
        '';
      }
      {
        plugin = nvim-treesitter.withAllGrammars;
        type = "lua";
        config = ''
          require("nvim-treesitter.configs").setup {
              highlight = {
                  enable = true
              }
          }
        '';
      }
      {
        plugin = telescope-nvim;
        type = "lua";
        config = ''
          local builtin = require("telescope.builtin")
          local themes = require("telescope.themes")
          local theme = themes.get_dropdown({})
          local diag = themes.get_dropdown({})
          diag.bufnr = 0

          vim.keymap.set("n", "<C-p>", function() builtin.find_files(theme) end, {})
          vim.keymap.set("n", "<leader>p", function() builtin.live_grep(theme) end, {})
        '';
      }
    ];
    extraLuaConfig = ''
      vim.cmd [[packadd packer.nvim]]

      vim.loader.enable()

      vim.opt.nu = true

      vim.opt.tabstop = 2
      vim.opt.softtabstop = 2
      vim.opt.shiftwidth = 2
      vim.opt.expandtab = true
      vim.opt.colorcolumn = "120"

      vim.opt.smartindent = true
      vim.opt.wrap = true
      vim.opt.swapfile = false
      vim.opt.backup = false

      vim.g.mapleader = " "

      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1

      vim.opt.termguicolors = true

      vim.api.nvim_create_autocmd({ "BufWritePre" }, {
        callback = function() vim.lsp.buf.format { async = false } end,
      })

      require("presence"):setup {
        auto_update = true,
        main_image = "file",
        buttons = true,
      }

      local mark = require("harpoon.mark")
      local ui = require("harpoon.ui")

      local set = vim.keymap.set

      set("n", "<C-a>", function() mark.add_file() end)
      set("n", "<C-o>", function() ui.toggle_quick_menu() end)
      set("n", "<A-h>", function() ui.nav_file(1) end)
      set("n", "<A-t>", function() ui.nav_file(2) end)
      set("n", "<A-g>", function() ui.nav_file(3) end)
      set("n", "<A-c>", function() ui.nav_file(4) end)

      vim.cmd("set cb+=unnamedplus")
      vim.cmd("set so=10")

      local function setKeys(keys)
        for k, v in pairs(keys) do
          vim.keymap.set("n", k, v)
        end
      end

      local keys = {
        ["<C-w>h"] = ":split<CR>",
        ["<C-t>"] = ":term<CR>a",
        ["<C-g>"] = ":TransparentToggle<CR>:colorscheme nix-${config.colorScheme.slug}<CR>",
      }
      setKeys(keys)

      local lsp = require("lsp-zero")

      lsp.preset("recommended")

      lsp.setup_servers({ "rust_analyzer", "lua_ls" })

      local cmp = require('cmp')
      local cmp_select = { behavior = cmp.SelectBehavior.Select }
      local cmp_mappings = lsp.defaults.cmp_mappings({
        ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
        ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
        ['<C-y>'] = cmp.mapping.confirm({ select = true }),
        ["<C-Space>"] = cmp.mapping.complete(),
      })

      lsp.set_preferences({
        sign_icons = {}
      })

      lsp.setup_nvim_cmp({
        mapping = cmp_mappings
      })

      lsp.on_attach(function(client, bufnr)
        local opts = { buffer = bufnr, remap = false }
        ih.on_attach(client, bufnr)

        vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
        vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
        vim.keymap.set("n", "<leader>ls", function() vim.lsp.buf.workspace_symbol() end, opts)
        vim.keymap.set("n", "<leader>ld", function() vim.diagnostic.open_float() end, opts)
        vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
        vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
        vim.keymap.set("n", "<leader>la", function() vim.lsp.buf.code_action() end, opts)
        vim.keymap.set("n", "<leader>lr", function() vim.lsp.buf.references() end, opts)
        vim.keymap.set("n", "<leader>ln", function() vim.lsp.buf.rename() end, opts)
        vim.keymap.set("n", "<C-f>", function() vim.lsp.buf.format { async = true } end, opts)
        vim.keymap.set("i", "<C-f>", function() vim.lsp.buf.format { async = true } end, opts)
        vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
      end)

      lsp.setup()
    '';
    enable = true;
    defaultEditor = true;
  };

  home.packages = with pkgs; [ tree-sitter lua-language-server ];
}
