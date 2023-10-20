{ config, lib, pkgs, ... }:

{
  programs.git = {
    enable = true;
    userEmail = "viwty@proton.me"; # It's in the GPG key anyway.
    userName = "viwty";
    signing = {
      signByDefault = true;
      key = "F25AC839D0DA7F72";
    };
  };

  programs.lazygit.enable = true;
}
