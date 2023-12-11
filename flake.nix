{
  description = "Funky";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-colors.url = "github:misterio77/nix-colors";

    nur.url = "github:nix-community/NUR";
  };
  outputs = { self, nixpkgs, nur, home-manager, hyprland, nix-colors, ... }@inputs:
    let inherit (self) outputs;
    in {
      overlays = import ./overlays { inherit inputs outputs; };
      nixosModules = import ./modules/nixos;
      homeManagerModules = import ./modules/home-manager;

      nixosConfigurations = {
        luna = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [
            nur.nixosModules.nur
            ./main/configuration.nix
          ];
        };
      };

      homeConfigurations = {
        "virtio@luna" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs nix-colors nur; };
          modules = [
            ./main/home.nix
          ];
        };
      };
    };
}
