{ config, lib, pkgs, nix-colors, ... }:

let
  inherit (nix-colors.lib-contrib { inherit pkgs; }) vimThemeFromScheme;
  theme = vimThemeFromScheme { scheme = config.colorScheme; };
in {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  xdg.configFile."nvim".recursive = true;
  xdg.configFile."nvim".source = ./config;

  xdg.configFile."nvim/colors.vim".text = theme.text;
  xdg.configFile."nvim/lua/font.lua".text = ''
  vim.o.guifont = "${config.font}:h26"
  '';

  home.packages = with pkgs; [ lua-language-server tree-sitter nil ];
}
