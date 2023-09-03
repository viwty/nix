{ config, lib, pkgs, ... }:

let colors = config.colorScheme.colors;
in {
  programs.rofi.enable = true;
  xdg.configFile."rofi/theme.rasi".text =
    import ./theme.nix { inherit colors; };
  programs.rofi = {
    package = pkgs.rofi-wayland;

    font = "Mononoki Nerd Font 22px";

    theme = "~/.config/rofi/theme.rasi";
  };
}
