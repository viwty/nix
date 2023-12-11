{ lib, pkgs, ... }:

{
  options = with lib; {
    wallpaper = mkOption {
      type = types.path;
      description = "The wallpaper to use";
    };
  };

  config = {
    home.packages = [ pkgs.swaybg ];
  };
}
