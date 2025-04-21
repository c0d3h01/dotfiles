{
  description = "Credit: Harshal (c0d3h01), NixOS Dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";
    flake-utils.url = "github:numtide/flake-utils";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix.url = "github:Gerg-L/spicetify-nix";

    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      flake-utils,
      ...
    }@inputs:
    let
      inherit (self) outputs;

      supportedSystems = [
        "aarch64-linux"
        "aarch64-darwin"
        "x86_64-linux"
        "x86_64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      # User Configuations
      userConfig = {
        username = "c0d3h01";
        fullName = "Harshal Sawant";
        email = "haarshalsawant@gmail.com";
        hostname = "NixOS";
        stateVersion = "24.11";
      };
    in
    {
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-tree);
      checks = forAllSystems (system: {
        pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
            alejandra.enable = true;
            statix.enable = true;
            deadnix.enable = true;
          };
        };
      });

      overlays = import ./overlays { inherit inputs; };

      # NixOS configuration with home-manager.
      nixosConfigurations.${userConfig.hostname} = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs outputs userConfig; };
        modules = [
          ./hosts/laptop # Host Modules <<-
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = { inherit inputs outputs userConfig; };
              users.${userConfig.username} = {
                imports = [ ./modules/home-manager/home.nix ];
              };
            };
          }
        ];
      };

      # Standalone home-manager configuration
      homeConfigurations = {
        "${userConfig.username}@${userConfig.hostname}" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs userConfig; };
          modules = [
            ./modules/home-manager/home.nix
            { nixpkgs.config.allowUnfree = true; }
          ];
        };
      };
    };
}
