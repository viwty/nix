{ inputs, outputs, lib, config, pkgs, ... }: {
  # You can import other NixOS modules here
  imports = [
    outputs.nixosModules.gpg
    ./desktop-hardware.nix
  ];

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
    ];
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

  services.xserver.windowManager.bspwm.enable = true;
  programs.hyprland.enable = true;
  programs.hyprland.nvidiaPatches = true;

  services.xserver.enable = true;
  services.xserver.displayManager.sddm = {
    enable = true;
    settings.Autologin = {
      User = "virtio";
      Session = "hyprland.desktop";
    };
  };

  # TODO: Set your hostname
  networking.hostName = "NixBTW";
  networking.extraHosts = ''
    192.168.100.100 pi
    46.29.236.25 vps
  '';

  time.timeZone = "Europe/Moscow";
  time.hardwareClockInLocalTime = true;

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

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

  networking.firewall = {
    enable = false;
  };
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
        name "My PipeWire Output"
      }
    '';
  };

  fonts.packages = with pkgs; [ (nerdfonts.override { fonts = [ "Mononoki" ]; }) ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "22.11";
}
