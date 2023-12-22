{ config, lib, pkgs, nix-colors, ... }:
{
  programs.nushell.enable = true;
  programs.starship = {
    enable = true;
    settings = {
      format = lib.concatStrings [
        "$username"
        "$hostname"
        "$directory"
        "$git_branch"
        "$git_state"
        "$git_status"
        "$cmd_duration"
        "$line_break"
        "$character"
      ];
      directory.style = "blue";
      character = {
        success_symbol = "[❯](purple)";
        error_symbol = "[❯](red)";
        vimcmd_symbol = "[❮](green)";
      };
      git_branch = {
        format = "[$branch]($style)";
        style = "bright-black";
      };
      git_status = {
        format =
          "[[(*$conflicted$untracked$modified$staged$renamed$deleted)](218) ($ahead_behind$stashed)]($style)";
        style = "cyan";
        conflicted = "";
        untracked = "";
        modified = "";
        staged = "";
        renamed = "";
        deleted = "";
        stashed = "";
      };
      git_state = {
        format = "([$state( $progress_current/$progress_total)]($style)) ";
        style = "bright-black";
      };
      cmd_duration = {
        format = "[$duration]($style) ";
        style = "yellow";
      };
    };
  };

  # extra stuff
  programs.bat.enable = true;
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  home.packages = with pkgs; [ waifu2x-converter-cpp ];

  programs.nushell = {
    shellAliases = {
      lg = "lazygit";
      v = ''
        fzf --bind 'enter:become(nvim {})'
      '';
      grep = "rg";
      cat = "bat";
      ddg = "lynx https://lite.duckduckgo.com/lite";
      waifu = "waifu2x-converter-cpp --scale-ratio 4 -i";
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
      def rebuild [] { git add .; home-manager switch --flake . }
      def fenWatch [] { watch -g '*.fnl' . {|op, path| if $op == "Create" {clear; fennel --add-package-path "?.lua;?/init.lua" --require-as-include --use-bit-lib -c $path | save -f $"(echo $path | str substring 0..-4).lua"}} }
    '';
  };
}
