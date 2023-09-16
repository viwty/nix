{ inputs, outputs, lib, config, pkgs, nix-colors, ... }:
let
  inherit (nix-colors.lib-contrib { inherit pkgs; })
    gtkThemeFromScheme colorSchemeFromPicture;
in {
  # You can import other home-manager modules here
  imports = [
    nix-colors.homeManagerModules.default
    outputs.homeManagerModules.hyprland
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
    outputs.homeManagerModules.neofetch
  ];

  colorScheme = nix-colors.colorSchemes.rose-pine;

  xdg.configFile."hypr/wallpaper.png".source = ./hexmaniac.png;

  nixpkgs = {
    overlays = with outputs.overlays; [ additions ];
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
    settings.id = 1129458952791400500;
    settings.format = {
      timestamp = "left";
      large_image = "cri";
      small_image = "";
    };
  };

  home.packages = with pkgs; [
    neofetch
    firefox-bin
    wireplumber
    ncmpcpp
    yt-dlp
    ffmpeg-full
    armcord
    btop
    killall
    ripgrep
    yue
    imagemagick
    mpv
    wf-recorder
    prismlauncher
    pcmanfm
    bitwarden
    gimp
    steam
    qpwgraph
    protontricks
    fzf
    virt-manager
    pulseaudio # for pactl
    gnome.gnome-calculator
    wine64
    winetricks
    p7zip
    craftos-pc
    pavucontrol
    ghidra
    ffmpegthumbnailer
    nixfmt
    piper
    tagger
    mpd-notification
    lutris
    qbittorrent
    nix-prefetch
    telegram-desktop
    sfz
    lynx
    man-pages
    sccache
  ];

  home.file.".mozilla/native-messaging-hosts/ff2mpv.json".source =
    "${pkgs.ff2mpv}/lib/mozilla/native-messaging-hosts/ff2mpv.json";

  gtk = { enable = true; };
  gtk.theme = {
    name = "${config.colorScheme.slug}";
    package = gtkThemeFromScheme { scheme = config.colorScheme; };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "22.11";
}
