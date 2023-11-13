{ inputs, outputs, lib, config, pkgs, nix-colors, nur, ... }:
let
  inherit (nix-colors.lib-contrib { inherit pkgs; })
    gtkThemeFromScheme colorSchemeFromPicture;
  wallpaper = ./clouds.png;
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

  #colorScheme = nix-colors.colorSchemes.catppuccin-mocha;
  colorScheme = colorSchemeFromPicture {
    path = wallpaper;
    kind = "dark";
  };
  xdg.configFile."hypr/wallpaper.png".source = wallpaper;

  nixpkgs = {
    overlays = with outputs.overlays; [ additions nur.overlay ];
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

  programs.firefox = {
    enable = true;
    profiles.default = {
      id = 0;
      search.default = "DuckDuckGo";
      search.force = true;
      bookmarks = [
        {
          name = "";
          url = "https://search.nixos.org/packages";
        }
        {
          name = "";
          url = "https://mipmip.github.io/home-manager-option-search/";
        }
        {
          name = "";
          url = "https://nur.nix-community.org/";
        }
      ];
      settings = {
        "browser.compactmode.show" = true;
        "browser.uidensity" = 1;
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      };
      userChrome = lib.readFile ./firefox.css;
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        privacy-badger
        darkreader
        ublock-origin
        bitwarden
        clearurls
        df-youtube
        don-t-fuck-with-paste
        enhanced-github
        firenvim
        sponsorblock
        dearrow
      ];
    };
  };

  home.packages = with pkgs; [
    neofetch
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
    ffmpegthumbnailer
    nixfmt
    piper
    mpd-notification
    qbittorrent
    nix-prefetch
    telegram-desktop
    sfz
    man-pages
    sccache
    nheko
    teamspeak_client
    picard
    mate.engrampa
    mangohud
  ];

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
