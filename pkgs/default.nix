{ pkgs ? (import ../nixpkgs.nix) { } }: {
  yue = pkgs.callPackage ./yue.nix { };
  fennel-language-server = pkgs.callPackage ./fennel-language-server.nix { };
}
