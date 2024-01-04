{ inputs, outputs, lib, config, pkgs, ... }: {
  # You can import other NixOS modules here
  imports = with outputs.nixosModules; [ gpg ./hardware.nix ];

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

  zramSwap.enable = true;

  services.postgresql = {
    enable = true;
    ensureDatabases = [ ];
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

  networking.hostName = "luna";
  networking.nameservers = [ "1.1.1.1" "1.1.0.0" ];
  networking.extraHosts = ''
    192.168.100.100 pi
    194.226.49.153 vps
    147.45.196.168 vpn
  '';

  time.timeZone = "Europe/Moscow";
  time.hardwareClockInLocalTime = true;

  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
    #enableCryptodisk = true;
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
  security.polkit.enable = true;
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
      privateKeyFile = "/home/virtio/.config/.wg0privkey";
      autostart = false;

      peers = [{
        publicKey = "YIVH1HPD1Hm78wzazKzLyHyg/0Ri1txSc2VnN/6BjwE=";
        presharedKeyFile = "/home/virtio/.config/wg0presharedkey";
        allowedIPs = [ "0.0.0.0/0" "::/0" ];
        endpoint = "147.45.196.168:56032";
      }];
    };
    wg1 = {
      address = [ "10.66.66.2/32" "fd42:42:42::2/128" ];
      dns = [ "1.1.1.1" "1.0.0.1" ];
      privateKeyFile = "/home/virtio/.config/wg1privkey";
      autostart = true;

      peers = [{
        publicKey = "DJOd3EDp7iB8k6mLiS3S67pVzlzmdvv9fRuHzzy/fXE=";
        presharedKeyFile = "/home/virtio/.config/wg1presharedkey";
        allowedIPs = [ "10.66.66.0/24" ];
        endpoint = "194.226.49.153:50868";
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
      extraPackages = with pkgs; [ vaapiVdpau libvdpau-va-gl vulkan-validation-layers];
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
