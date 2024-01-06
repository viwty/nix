{ pkgs ? (import ../nixpkgs.nix) { } }: {
  fennel-ls = pkgs.callPackage ./fennel-ls.nix { };
}
