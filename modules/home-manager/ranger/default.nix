{ config, lib, pkgs, ... }:

{
  home.packages = [ pkgs.ranger ];
  xdg.configFile."ranger/rc.conf".text = ''
  '';
}
