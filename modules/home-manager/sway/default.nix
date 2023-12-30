{ config, lib, pkgs, ... }:

let
  wallpaper = config.wallpaper;
  c = config;
  swayer = pkgs.writeShellScriptBin "swayer" ''
    # https://github.com/crispyricepc/sway-nvidia
    # Hardware cursors not yet working on wlroots
    export WLR_NO_HARDWARE_CURSORS=1
    # Set wlroots renderer to Vulkan to avoid flickering
    export WLR_RENDERER=vulkan
    # General wayland environment variables
    export XDG_SESSION_TYPE=wayland
    export QT_QPA_PLATFORM=wayland
    export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
    # Firefox wayland environment variable
    export MOZ_ENABLE_WAYLAND=1
    export MOZ_USE_XINPUT2=1
    # OpenGL Variables
    export GBM_BACKEND=nvidia-drm
    export __GL_GSYNC_ALLOWED=0
    export __GL_VRR_ALLOWED=0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia

    sway --unsupported-gpu
  '';
  colors = config.colorScheme.colors;
in {
  options = with lib; {
    terminal = mkOption {
      type = types.string;
      description = "The terminal to use";
    };
  };

  config = {
    wayland.windowManager.sway = {
      enable = true;

      extraConfig = ''
        for_window [title="TermFloat"] floating enable
        client.focused          ${colors.base05} ${colors.base0D} ${colors.base00} ${colors.base0D} ${colors.base0D}
        client.focused_inactive ${colors.base01} ${colors.base01} ${colors.base05} ${colors.base03} ${colors.base01}
        client.unfocused        ${colors.base01} ${colors.base00} ${colors.base05} ${colors.base01} ${colors.base01}
        client.urgent           ${colors.base08} ${colors.base08} ${colors.base00} ${colors.base08} ${colors.base08}
      '';

      config = let mod = "Mod4";
      in {
        modifier = mod;
        terminal = c.terminal;

        keybindings = lib.mapAttrs'
          (key: cmd: lib.attrsets.nameValuePair ("${mod}+" + key) (cmd)) {
            "Return" = "exec alacritty -e tmux";
            "Shift+Return" = "exec alacritty -e tmux attach";
            "q" = "kill";
            "p" = "exec firefox";
            "c" = "exec alacritty -T TermFloat -e clip";
            "r" = "exec alacritty -T TermFloat -e ncmpcpp";
            "u" = "exec pcmanfm";
            "Space" = "exec rofi -show drun";
            "l" = "exec sc grimshot";
            "Shift+l" = "exec scwin grimshot";
            "j" = "exec gnome-calculator";
            "d" = "focus left";
            "h" = "focus down";
            "t" = "focus up";
            "n" = "focus right";
            "Shift+d" = "move left";
            "Shift+t" = "move down";
            "Shift+n" = "move up";
            "Shift+s" = "move right";
            "f" = "exec wl-paste | paste";
            "w" = "splith";
            "v" = "splitv";
            "m" = "fullscreen toggle";
            "o" = "floating toggle";
            "e" = "workspace dc";
            "Shift+e" = "move container to workspace dc";
            "1" = "workspace number 1";
            "2" = "workspace number 2";
            "3" = "workspace number 3";
            "4" = "workspace number 4";
            "5" = "workspace number 5";
            "6" = "workspace number 6";
            "7" = "workspace number 7";
            "8" = "workspace number 8";
            "9" = "workspace number 9";
            "Shift+1" = "move container to workspace number 1";
            "Shift+2" = "move container to workspace number 2";
            "Shift+3" = "move container to workspace number 3";
            "Shift+4" = "move container to workspace number 4";
            "Shift+5" = "move container to workspace number 5";
            "Shift+6" = "move container to workspace number 6";
            "Shift+7" = "move container to workspace number 7";
            "Shift+8" = "move container to workspace number 8";
            "Shift+9" = "move container to workspace number 9";
            "Shift+Escape" = "reload";
          };

        assigns = { "dc" = [{ class = "VencordDesktop"; }]; };

        startup = map (cmd: { command = cmd; }) [
          "vencorddesktop --no-sandbox"
          "mpc play"
          "pcmanfm --daemon-mode"
        ];

        bars = [ ];

        fonts = { names = [ c.font ]; };

        focus.followMouse = true;

        input = {
          "*" = {
            xkb_layout = "us,ru";
            xkb_variant = "dvorak,";
            xkb_options = "grp:alt_shift_toggle,caps:escape";
            accel_profile = "flat";
          };
        };
        output = { "*" = { bg = "${wallpaper} fill"; }; };
        workspaceOutputAssign = [
          {
            workspace = "9";
            output = "HDMI-A-2";
          }
          {
            workspace = "dc";
            output = "HDMI-A-1";
          }
        ];

        gaps = {
          inner = 15;
        };
      };
    };

    home.packages = with pkgs; [
      mpc-cli
      imv
      sway-contrib.grimshot
      wl-clipboard
      xdg-desktop-portal-wlr
      swayer
    ];
  };
}
