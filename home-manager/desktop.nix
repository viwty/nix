{ inputs, outputs, lib, config, pkgs, nix-colors, ... }:

let inherit (nix-colors.lib-contrib { inherit pkgs; }) gtkThemeFromScheme;
in {
  # You can import other home-manager modules here
  imports = [
    nix-colors.homeManagerModules.default
    outputs.homeManagerModules.hyprland
    outputs.homeManagerModules.bspwm
    outputs.homeManagerModules.alacritty
    outputs.homeManagerModules.tmux
    outputs.homeManagerModules.rofi
    outputs.homeManagerModules.scripts
    outputs.homeManagerModules.desktopEntries
    outputs.homeManagerModules.rustup
    outputs.homeManagerModules.git
    outputs.homeManagerModules.neovim
    outputs.homeManagerModules.shell
    outputs.homeManagerModules.mako
    #outputs.homeManagerModules.ranger
  ];

  colorScheme = nix-colors.colorSchemes.nord;

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      (final: prev: {
        ranger-sixel = prev.ranger.overrideAttrs (oldAttrs: {
          patches = (oldAttrs.patches or [ ]) ++ [
            (prev.fetchpatch {
              url =
                "https://github.com/3ap/ranger/commit/ef9ec1f0e0786e2935c233e4321684514c2c6553.patch";
              sha256 = "sha256-MJbIBuFeOvYnF6KntWJ2ODQ4KAcbnFEQ1axt1iQGkWY=";
            })
          ];
        });
      })
    ];
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

  home = {
    username = "virtio";
    homeDirectory = "/home/virtio";
  };

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git.enable = true;

  services.mpd-discord-rpc = {
    enable = true;
    settings.format = {
      timestamp = "left";
      large_image = "cri";
      small_image = "";
    };
  };

  home.packages = with pkgs; [
    neofetch
    firefox-bin
    hyprpaper
    slurp
    grim
    wl-clipboard
    wireplumber
    ncmpcpp
    yt-dlp
    ffmpeg-full
    armcord
    btop
    killall
    lua53Packages.fennel
    fnlfmt
    ripgrep
    yue
    rust-analyzer
    imagemagick
    mpv
    wf-recorder
    imv
    prismlauncher
    pkg-config
    pcmanfm
    bitwarden
    gimp
    steam
    qpwgraph
    ark
    protontricks
    fzf
    sshfs
    virt-manager
    sccache
    blender
    pulseaudio # for pactl
    gnome.gnome-calculator
    wine64
    winetricks
    p7zip
    craftos-pc
    pavucontrol
    nvtop
    ghidra
    ffmpegthumbnailer
    nixfmt
    piper
    tagger
    mpd-notification
    thunderbird
    lutris
    qbittorrent
  ];

  home.file.".mozilla/native-messaging-hosts/ff2mpv.json".source =
    "${pkgs.ff2mpv}/lib/mozilla/native-messaging-hosts/ff2mpv.json";

  gtk = {
    enable = true;
  };
  gtk.theme = {
    name = "${config.colorScheme.slug}";
    package = gtkThemeFromScheme { scheme = config.colorScheme; };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "22.11";
}
