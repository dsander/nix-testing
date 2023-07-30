{
  description = "My first nix flake";

  inputs = {
      nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-23.05-darwin";
      home-manager.url = "github:nix-community/home-manager/release-23.05";
      home-manager.inputs.nixpkgs.follows = "nixpkgs";
      darwin.url = "github:lnl7/nix-darwin";
      darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, darwin, ... }: {
    darwinConfigurations."slartibartfast" = darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [ home-manager.darwinModules.home-manager ./hosts/slartibartfast/default.nix ];
    };
    darwinConfigurations."magrathea" = darwin.lib.darwinSystem {
      inputs = { inherit nixpkgs; };
      system = "aarch64-darwin";
      modules = [ 
        home-manager.darwinModules.home-manager
          ./.config/darwin/darwin-configuration.nix
          ./hosts/magrathea/default.nix
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.alex = import ./.config/darwin/home.nix;  
        }
      ];
    };
  };
}