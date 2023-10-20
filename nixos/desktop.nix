{ inputs, outputs, lib, config, pkgs, ... }: {
  # You can import other NixOS modules here
  imports = [ outputs.nixosModules.gpg ./desktop-hardware.nix ];

  nixpkgs = {
    overlays = [ outputs.overlays.additions ];
    config = { allowUnfree = true; };
  };

  nix = {
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}")
      config.nix.registry;

    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
    };
  };

  #services.xserver.windowManager.bspwm.enable = true;
  programs.hyprland.enable = true;
  programs.hyprland.enableNvidiaPatches = true;
  zramSwap.enable = true;

  services.xserver.enable = true;
  services.xserver.displayManager.sddm = {
    enable = true;
      settings.Autologin = {
        Session = "hyprland.desktop";
        User = "virtio";
        Relogin = true;
    };
  };

  services.postgresql = {
    enable = true;
    ensureDatabases = [];
    enableTCPIP = true;
    # port = 5432;
    authentication = pkgs.lib.mkOverride 10 ''
      #type database  DBuser  auth-method
      local all       all     trust
      #type database DBuser origin-address auth-method
      # ipv4
      host  all      all     127.0.0.1/32   trust
      # ipv6
      host all       all     ::1/128        trust
    '';
    initialScript = pkgs.writeText "backend-initScript" ''
      CREATE ROLE virtio WITH LOGIN PASSWORD 'virtio' CREATEDB;
      GRANT ALL PRIVILEGES ON DATABASE autovirt TO virtio;
    '';

     
    identMap = ''
      # ArbitraryMapName systemUser DBUser
       superuser_map      root      postgres
       superuser_map      postgres  postgres
       # Let other names login as themselves
       superuser_map      virtio    postgres
    '';
  };

  # TODO: Set your hostname
  networking.hostName = "NixBTW";
  networking.extraHosts = ''
    192.168.100.100 pi
    46.29.236.25 vps
  '';

  time.timeZone = "Europe/Moscow";
  time.hardwareClockInLocalTime = true;

  boot.loader.grub = {
   enable = true;
   device = "/dev/sda";
   useOSProber = true;
   enableCryptodisk = true;
  };

  users.users.virtio = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "libvirtd" ];
    shell = pkgs.nushell;
  };
  programs.dconf.enable = true;

  virtualisation.libvirtd.enable = true;
  virtualisation.docker.enable = true;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  services.ratbagd.enable = true;

  networking.firewall = { enable = false; };
  networking.wg-quick.interfaces = {
    wg0 = {
      address = [ "10.66.66.2/32" "fd42:42:42::2/128" ];
      dns = [ "1.1.1.1" "1.0.0.1" ];
      privateKeyFile = "/home/virtio/.wgprivkey";

      peers = [{
        publicKey = "GzIe5T+UPu6rg6PV/hCY1EycppeTSlhJHgQBEhVGjDo=";
        presharedKeyFile = "/home/virtio/.wgpresharedkey";
        allowedIPs = [ "0.0.0.0/0" "::/0" ];
        endpoint = "46.29.236.25:51820";
      }];
    };
  };

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware = {
    nvidia = {
      open = false;
      modesetting.enable = true;
    };
    opengl = {
      enable = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [ vaapiVdpau libvdpau-va-gl ];
    };
    opentabletdriver = { enable = true; };
  };

  systemd.services.mpd.environment = { XDG_RUNTIME_DIR = "/run/user/1000"; };

  services.gvfs.enable = true;

  services.mpd = {
    enable = true;
    musicDirectory = "/home/virtio/music";
    user = "virtio";
    extraConfig = ''
      audio_output {
        type "pipewire"
        name "pipe"
      }
    '';
  };

  fonts.packages = with pkgs;
    [ (nerdfonts.override { fonts = [ "Iosevka" ]; }) ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "22.11";
}
