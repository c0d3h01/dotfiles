{
  description = "Home Manager configuration of c0d3h01";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }:
    let
      inherit (nixpkgs) lib;

      supportedSystems = [
        "x86_64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      forAllSystems = lib.genAttrs supportedSystems;

      pkgsFor =
        system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

      fmtFor =
        system:
        import ./lib/formatter.nix {
          pkgs = pkgsFor system;
          inherit self;
        };

      mkHome =
        system:
        home-manager.lib.homeManagerConfiguration {
          pkgs = pkgsFor system;
          modules = [ ./homeManager.nix ];
          extraSpecialArgs = {
            inherit self;
            hostConfig = {
              username = "c0d3h01";
              inherit system;
            };
          };
        };
    in
    {
      homeConfigurations = {
        c0d3h01 = mkHome "x86_64-linux";
      }
      // lib.listToAttrs (
        map (system: {
          name = "c0d3h01@${system}";
          value = mkHome system;
        }) supportedSystems
      );

      devShells = forAllSystems (system: {
        default = import ./lib/shell.nix {
          pkgs = pkgsFor system;
          inherit (fmtFor system) formatter;
        };
      });

      formatter = forAllSystems (system: (fmtFor system).formatter);

      checks = forAllSystems (system: {
        formatting = (fmtFor system).check;
      });

      packages = forAllSystems (system: import ./lib/scripts.nix { pkgs = pkgsFor system; });
    };
}
