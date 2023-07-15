{ pkgs, lib, config, pkgs-stable, ... }:
let colors = config.colorScheme.colors;
in {
    programs.zellij.enable = true;
    xdg.configFile."zellij/config.kdl".source = ./config.kdl;
    xdg.configFile."zellij/layouts/default.kdl".source = ./default.kdl;
    xdg.configFile."zellij/themes/default.kdl".text = ''
    themes {
      default {
        fg      "#${colors.base05}"
        bg      "#${colors.base02}"
        black   "#${colors.base00}"
        red     "#${colors.base08}"
        green   "#${colors.base0B}"
        yellow  "#${colors.base0A}"
        blue    "#${colors.base0D}"
        magenta "#${colors.base0E}"
        cyan    "#${colors.base0C}"
        white   "#${colors.base05}"
        orange  "#${colors.base09}"
    }
    '';
}
