{ config, lib, pkgs, ... }:

{
  xdg.desktopEntries = {
    vencorddesktop = {
      name = "Vesktop";
      exec = "vencorddesktop --no-sandbox %U";
      icon = "vencorddesktop";
      terminal = false;
    };
    craftos = {
      name = "CraftOS-PC";
      exec = "env SDL_VIDEODRIVER=wayland craftos";
      terminal = false;
      categories = [ "Utility" "Development" ];
    };
  };
}
