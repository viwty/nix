{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [ rustup gcc ];
}
