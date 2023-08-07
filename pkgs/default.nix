# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example' or (legacy) 'nix-build -A example'

{ pkgs ? (import ../nixpkgs.nix) { } }: {
  # example = pkgs.callPackage ./example { };
  yue = pkgs.callPackage ./yue.nix { };
  mpd-notification = pkgs.callPackage ./mpd-notification.nix { };
}
