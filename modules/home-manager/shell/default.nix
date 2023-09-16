{ config, lib, pkgs, nix-colors, ... }:

let inherit (nix-colors.lib-contrib { inherit pkgs; }) shellThemeFromScheme;
in {
  programs.nushell.enable = true;
  programs.starship.enable = true;

  # extra stuff
  programs.bat.enable = true;
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.nushell = {
    shellAliases = {
      lg = "lazygit";
      v = "fzf --bind 'enter:become(nvim {})'\n";
      grep = "rg";
      cat = "bat";
      ddg = "lynx https://lite.duckduckgo.com/lite";
    };
    envFile.text = ''
      $env.NIXPKGS_ALLOW_UNFREE = 1
      $env.PATH = ($env.PATH | split row (char esep) | prepend '/home/virtio/.cargo/bin')
      $env.RUSTC_WRAPPER = (which sccache | get path)

      $env.config = {
        show_banner: false
      }
    '';
    extraConfig = ''
      def useflake () { echo "use flake" | save .envrc; direnv allow }
    '';
  };
}
