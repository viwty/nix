{ pkgs, ... }: {
  systemd.services.keyd = {
    description = "key remapping daemon";
    wantedBy = [ "sysinit.target" ];
    requires = [ "local-fs.target" ];
    after = [ "local-fs.target" ];
    environment.KEYD_CONFIG_DIR = ./cfg;
    serviceConfig.ExecStart = "${pkgs.keyd}/bin/keyd";
  };
}
