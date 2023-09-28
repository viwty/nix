{ config, lib, pkgs, ... }:

{
  programs.git = {
    enable = true;
    userEmail = "viwty@proton.me"; # It's in the GPG key anyway.
    userName = "viwty";
    signing = {
      signByDefault = true;
      key = "54AA28B7A3494432";
    };
  };

  programs.lazygit.enable = true;
}
