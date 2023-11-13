{ config, lib, pkgs, ... }:

{
  programs.git = {
    enable = true;
    userEmail = "viwty@proton.me"; # It's in the GPG key anyway.
    userName = "viwty";
    signing = {
      signByDefault = true;
      key = "21A5767FFB7C88D3";
    };
  };

  programs.lazygit.enable = true;
}
