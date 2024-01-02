{ config, lib, pkgs, ... }:

let 
  cc = ./cc;
  urn = pkgs.writeShellScriptBin "urn" ''
    ${pkgs.urn}/bin/urn --include ${cc} $@
  '';
in {
  home.packages = [urn];
}
