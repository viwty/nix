{ pkgs ? (import ../nixpkgs.nix) { } }: {
  yue = pkgs.callPackage ./yue.nix { };
  fennel-ls = pkgs.callPackage ./fennel-ls.nix { };
}
