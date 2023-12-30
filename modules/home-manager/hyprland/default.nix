{ config, pkgs, ... }:

let
  colors = config.colorScheme.colors;
  wallpaper = config.wallpaper;
  hypr = pkgs.writeShellScriptBin "hypr" ''
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

    Hyprland
  '';
in {

  home.packages = with pkgs; [
    hyprpicker
    mpc-cli
    imv
    grimblast
    wl-clipboard
    xdg-desktop-portal-hyprland
    hypr
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    extraConfig = ''
      exec-once=swaybg -i ${wallpaper}
      exec-once=pcmanfm --daemon-mode
      exec-once=mpc play
      exec-once=vencorddesktop --no-sandbox

      bezier=easing, 0.34, 1.56, 0.64, 1
      animation=global, 1, 6, easing
      animation=workspaces, 1, 6, easing, slidevert

      windowrulev2 = immediate, class:^(Terraria)

      decoration {
        rounding = 12
        blur {
          enabled = true
          size = 4
          passes = 2
        }
      }

      env = LIBVA_DRIVER_NAME, nvidia
      env = XDG_SESSION_TYPE, wayland
      env = GBM_BACKEND, nvidia-drm
      env = WLR_NO_HARDWARE_CURSORS, 1
      env = MOZ_ENABLE_WAYLAND, 1
      env = WLR_DRM_NO_ATOMIC, 1

      #windowrulev2 = immediate, class:^(steam_app)

      windowrule=float, title:^(TermFloat)(.*)$
      windowrule=workspace 10, class:^(VencordDesktop)$

      bind=SUPER, j, exec, gnome-calculator
      bind=SUPER, g, exec, hyprpicker -a
      bind=SUPER, return, exec, alacritty -e tmux
      bind=SUPERSHIFT, return, exec, alacritty -e tmux attach
      bind=SUPER, space, exec, rofi -show drun
      bind=SUPER, p, exec, firefox
      bind=SUPER, l, exec, sc grimblast
      bind=SUPERSHIFT, l, exec, scwin grimblast
      bind=SUPER, c, exec, [noanim] alacritty -T TermFloat -e clip
      bind=SUPER, r, exec, [noanim] alacritty -T TermFloat -e ncmpcpp
      bind=SUPER, u, exec, pcmanfm
      bind=SUPER, q, killactive
      bind=SUPER, MINUS, exec, config-reload
      bind=SUPER, y, exec, firefox https://mail.proton.me/u/1/inbox

      bind=SUPER, i, exec, hypr-toggle

      bind=SUPER, o, togglefloating
      bind=SUPER, m, fullscreen, 0

      bind=SUPER, d, movefocus, l
      bind=SUPER, h, movefocus, d
      bind=SUPER, t, movefocus, u
      bind=SUPER, n, movefocus, r
      bind=SUPERSHIFT, d, movewindow, l
      bind=SUPERSHIFT, h, movewindow, d
      bind=SUPERSHIFT, t, movewindow, u
      bind=SUPERSHIFT, n, movewindow, r

      bind=SUPER, f, exec, wl-paste | paste

      bind=SUPER, e, workspace, 10
      bind=SUPERSHIFT, e, movetoworkspacesilent, 10
      bind=SUPER, 1, workspace, 1
      bind=SUPER, 2, workspace, 2
      bind=SUPER, 3, workspace, 3
      bind=SUPER, 4, workspace, 4
      bind=SUPER, 5, workspace, 5
      bind=SUPER, 6, workspace, 6
      bind=SUPER, 7, workspace, 7
      bind=SUPER, 8, workspace, 8
      bind=SUPER, 9, workspace, 9

      bind=SUPERSHIFT, 1, movetoworkspacesilent, 1
      bind=SUPERSHIFT, 2, movetoworkspacesilent, 2
      bind=SUPERSHIFT, 3, movetoworkspacesilent, 3
      bind=SUPERSHIFT, 4, movetoworkspacesilent, 4
      bind=SUPERSHIFT, 5, movetoworkspacesilent, 5
      bind=SUPERSHIFT, 6, movetoworkspacesilent, 6
      bind=SUPERSHIFT, 7, movetoworkspacesilent, 7
      bind=SUPERSHIFT, 8, movetoworkspacesilent, 8
      bind=SUPERSHIFT, 9, movetoworkspacesilent, 9

      bindm=SUPER, mouse:272, movewindow
      bindm=SUPER, mouse:273, resizewindow

      general {
        gaps_out = 10
        gaps_in = 5
        border_size = 2
        col.active_border=0xff${colors.base0C}
        col.inactive_border=0xff${colors.base02}
        allow_tearing = true
      }

      input {
        kb_options = caps:escape, grp:alt_shift_toggle
        kb_layout = us, ru
        kb_variant = dvorak,
        accel_profile = flat
      }

      monitor=HDMI-A-1, highres, 0x0, 1
      monitor=HDMI-A-2, highres, 1920x0, 1

      workspace=HDMI-A-2, 9
    '';
  };
}
