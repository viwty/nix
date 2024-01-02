{ outputs, config, lib, pkgs, nix-colors, nur, ... }:
let
  inherit (nix-colors.lib-contrib { inherit pkgs; })
    gtkThemeFromScheme colorSchemeFromPicture nixWallpaperFromScheme;
  colors = config.colorScheme.colors;
in {
  imports = [ nix-colors.homeManagerModules.default ]
    ++ (with outputs.homeManagerModules; [
      swaybg
      hyprland
      alacritty
      rofi
      scripts
      desktopEntries
      neovim
      shell
      mako
      neofetch
      urn
      ./pkgs.nix
    ]);

  options = {
    font = lib.mkOption {
      type = lib.types.str;
      description = "System wide font";
    };
  };

  config = {
    wallpaper = ./wallpapers/somniphobic-stargazers.png;
    font = "Iosevka Nerd Font";
    colorScheme = nix-colors.colorSchemes.nord;
    #colorScheme = (let wallpaper = config.wallpaper;
    #in colorSchemeFromPicture {
    #  path = wallpaper;
    #  kind = "dark";
    #});
    #wallpaper = nixWallpaperFromScheme {
    #  scheme = config.colorScheme;
    #  width = 1920;
    #  height = 1080;
    #  logoScale = 6.0;
    #};

    nixpkgs = {
      overlays = with outputs.overlays; [ additions nur.overlay ];
      config = {
        allowUnfree = true;
        allowUnfreePredicate = (_: true);
        permittedInsecurePackages = [ "electron-25.9.0" ];
      };
    };

    home = {
      username = "virtio";
      homeDirectory = "/home/virtio";
    };

    programs.home-manager.enable = true;

    programs.firefox = {
      enable = true;
      profiles.default = {
        id = 0;
        search.default = "DuckDuckGo";
        search.force = true;
        bookmarks = [
          {
            name = "Package search";
            url = "https://search.nixos.org/packages";
          }
          {
            name = "Option search";
            url = "https://mipmip.github.io/home-manager-option-search/";
          }
          {
            name = "NUR search";
            url = "https://nur.nix-community.org/";
          }
          {
            name = "Yandex image search";
            url = "https://yandex.ru/images";
          }
          {
            name = "Fennel reference";
            url = "https://fennel-lang.org/reference";
          }
          {
            name = "Urn symbol index";
            url = "https://urn-lang.com/docs/";
          }
        ];
        settings = {
          "browser.compactmode.show" = true;
          "browser.uidensity" = 1;
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          "devtools.onboarding.telemetry.logged" = false;
          "browser.newtabpage.activity-stream.feeds.telemetry" = false;
          "browser.newtabpage.activity-stream.telemetry" = false;
          "browser.ping-centre.telemetry" = false;
          "toolkit.telemetry.bhrPing.enabled" = false;
          "toolkit.telemetry.enabled" = false;
          "toolkit.telemetry.firstShutdownPing.enabled" = false;
          "toolkit.telemetry.hybridContent.enabled" = false;
          "toolkit.telemetry.newProfilePing.enabled" = false;
          "toolkit.telemetry.shutdownPingSender.enabled" = false;
          "toolkit.telemetry.unified" = false;
          "toolkit.telemetry.updatePing.enabled" = false;
          "toolkit.telemetry.reportingpolicy.firstRun" = false;
          "toolkit.telemetry.archive.enabled" = false;
          "datareporting.healthreport.uploadEnabled" = false;
          "datareporting.policy.dataSubmissionEnabled" = false;
          "datareporting.sessions.current.clean" = true;
        };
        extensions = with pkgs.nur.repos.rycee.firefox-addons; [
          privacy-badger
          darkreader
          ublock-origin
          bitwarden
          clearurls
          df-youtube
          don-t-fuck-with-paste
          enhanced-github
          sponsorblock
          dearrow
          user-agent-string-switcher
        ];
      };
    };

    programs.tmux = {
      enable = true;
      keyMode = "vi";
      mouse = true;
      prefix = "C-Space";
      clock24 = true;

      plugins = with pkgs.tmuxPlugins; [ vim-tmux-navigator ];

      baseIndex = 1;
      extraConfig = ''
        set-option -g status-position top
        set-option -ga terminal-overrides ",alacritty:Tc"
        set -g default-terminal "alacritty"
        unbind r

        unbind v
        unbind h
        unbind %
        unbind '"'
        set -g focus-events on
        set -g status-style bg=default
        set -g status-left-length 90
        set -g status-right-length 90
        set -g status-justify centre

        bind v split-window -h -c "#{pane_current_path}"
        bind h split-window -v -c "#{pane_current_path}"

        bind n command-prompt "rename window '%%'"
        bind w new-window -c "#{pane_current_path}"

        bind -n M-j previous-window
        bind -n M-k next-window

        set -sg escape-time 0

        is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
            | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|l?n?vim?x?)(diff)?$'"
        bind-key -n 'C-h' if-shell "$is_vim" 'send-keys C-h'  'select-pane -L'
        bind-key -n 'C-j' if-shell "$is_vim" 'send-keys C-j'  'select-pane -D'
        bind-key -n 'C-k' if-shell "$is_vim" 'send-keys C-k'  'select-pane -U'
        bind-key -n 'C-l' if-shell "$is_vim" 'send-keys C-l'  'select-pane -R'

        bind-key -T copy-mode-vi 'C-h' select-pane -L
        bind-key -T copy-mode-vi 'C-j' select-pane -D
        bind-key -T copy-mode-vi 'C-k' select-pane -U
        bind-key -T copy-mode-vi 'C-l' select-pane -R

        # funky colors
        set-window-option -g window-status-current-style "bg=#${colors.base05},fg=#${colors.base00}"
        set-option -g status-style "fg=#${colors.base05},bg=#${colors.base00}"

        # default window title colors
        set-window-option -g window-status-style "fg=#${colors.base04},bg=default"

        # active window title colors
        set-window-option -g window-status-current-style "fg=#${colors.base0A},bg=default"

        # pane border
        set-option -g pane-border-style "fg=#${colors.base01}"
        set-option -g pane-active-border-style "fg=#${colors.base02}"

        # message text
        set-option -g message-style "fg=#${colors.base05},bg=#${colors.base01}"

        # pane number display
        set-option -g display-panes-active-colour "#${colors.base0B}"
        set-option -g display-panes-colour "#${colors.base0A}"

        # clock
        set-window-option -g clock-mode-colour "#${colors.base0B}"

        # copy mode highligh
        set-window-option -g mode-style "fg=#${colors.base04},bg=#${colors.base02}"

        # bell
        set-window-option -g window-status-bell-style "fg=#${colors.base01},bg=#${colors.base08}"
      '';
    };

    programs.git = {
      enable = true;
      userEmail = "viwty@proton.me"; # It's in the GPG key anyway.
      userName = "viwty";
      signing = {
        signByDefault = true;
        key = "21A5767FFB7C88D3";
      };
    };

    programs.lazygit.enable = true;

    gtk = {
      enable = true;
      theme = {
        name = config.colorScheme.slug;
        package = gtkThemeFromScheme { scheme = config.colorScheme; };
      };
      cursorTheme = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Normal-Classic";
      };
    };

    # Nicely reload system units when changing configs
    systemd.user.startServices = "sd-switch";

    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    home.stateVersion = "22.11";
  };
}
