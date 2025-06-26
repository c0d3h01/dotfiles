{
  description = "NixOS Flake: WorkSpace";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable-small";

    systems.url = "github:nix-systems/default";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:c0d3h01/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
    pre-commit-hooks.inputs.nixpkgs.follows = "nixpkgs";

    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      ...
    }:
    let
      userConfig = {
        hostname = "devbox";
        username = "c0d3h01";
        fullName = "Harshal Sawant";
      };

      system = "x86_64-linux";

      machineModule = name: ./machines/${name};
      homeModule = ./homeManager/home.nix;

      homeConfigurations = {
        "${userConfig.username}@${userConfig.hostname}" = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            system = "x86_64-linux";
            config.allowUnfree = true;
          };
          extraSpecialArgs = {
            inherit inputs self userConfig;
          };
          modules = [ homeModule ];
        };
      };
    in
    {
      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt-tree;

      inherit homeConfigurations;

      nixosConfigurations.${userConfig.hostname} = nixpkgs.lib.nixosSystem {
        system = "${system}";
        specialArgs = {
          inherit inputs self userConfig;
        };
        modules = [
          (machineModule userConfig.username)
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {
                inherit inputs self userConfig;
              };
              users.${userConfig.username} = {
                imports = [ homeModule ];
              };
            };
          }
        ];
      };
    };
}
