{ config, lib, pkgs, nix-colors, ... }:

let inherit (nix-colors.lib-contrib { inherit pkgs; }) shellThemeFromScheme;
in {
  programs.nushell.enable = true;
  programs.starship.enable = true;

  # extra stuff
  programs.bat.enable = true;
  programs.exa.enable = true;
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.nushell = {
    shellAliases = {
      lg = "lazygit";
      v = "fzf --bind 'enter:become(nvim {})'\n";
      cat = "bat";
      useflake = "echo \"use flake\" > .envrc; direnv allow";
      ddg = "lynx https://lite.duckduckgo.com/lite";
    };
    envFile.text = ''
      $env.NIXPKGS_ALLOW_UNFREE = 1
      $env.PATH = ($env.PATH | split row (char esep) | prepend '/home/virtio/.cargo/bin')

      $env.config = {
        show_banner: false
      }
    '';
  };
}
