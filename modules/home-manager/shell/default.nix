{ config, lib, pkgs, nix-colors, ... }:
{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
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
        success_symbol = "[>](purple)";
        error_symbol = "[>](red)";
        vimcmd_symbol = "[<](green)";
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
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  # thefuck is THE program you need on any linux install
  home.packages = with pkgs; [ waifu2x-converter-cpp zsh-z thefuck ];
  xdg.configFile."zsh/z".text = ''
  source ${pkgs.zsh-z.outPath}/share/zsh-z/zsh-z.plugin.zsh
  '';
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    autocd = true;
    dotDir = ".config/zsh";
    shellAliases = {
      lg = "lazygit";
      grep = "rg";
      cat = "bat";
      waifu = "waifu2x-converter-cpp --scale-ratio 4 -i";
    };
    envExtra = ''
      export PATH=/home/virtio/.cargo/bin:$PATH
      RUSTC_WRAPPER="$(which sccache)"
      export RUSTC_WRAPPER
      EDITOR=nvim
      export EDITOR
    '';
    initExtra = builtins.readFile ./zinit;
  };
}
