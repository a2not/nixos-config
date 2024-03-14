{
  # kickstarted from https://github.com/Misterio77/nix-starter-configs
  description = "NixOS configs";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # TODO: flake-utils to enable multiple system
    # flake-utils.url = "github:numtide/flake-utils";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    inherit (self) outputs;

    systemSettings = {
      system = "x86_64-linux";
      hostname = "nixos";
      timezone = "Asia/Tokyo";
      locale = "en_US.UTF-8";
      stateVersion = "23.11";
    };

    userSettings = {
      username = "a2not";
      name = "a2not";
      email = "a2not.dev@gmail.com";
    };
  in {
    inherit systemSettings userSettings;

    nixosConfigurations.system = nixpkgs.lib.nixosSystem {
      system = systemSettings.system;
      specialArgs = {
        inherit inputs outputs;
        inherit systemSettings;
        inherit userSettings;
      };
      modules = [
        ./nixos/configuration.nix
      ];
    };

    homeConfigurations.user = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.${systemSettings.system}; # Home-manager requires 'pkgs' instance
      extraSpecialArgs = {
        inherit inputs outputs;
        inherit systemSettings;
        inherit userSettings;
      };
      modules = [
        ./home-manager/home.nix
      ];
    };

    # NOTE: in case if i want to use home-manager as a NixOS module instead of standalone
    # { inputs, outputs, ... }: {
    #   imports = [
    #     # Import home-manager's NixOS module
    #     inputs.home-manager.nixosModules.home-manager
    #   ];
    #
    #   home-manager = {
    #     extraSpecialArgs = { inherit inputs outputs; };
    #     users = {
    #       # Import your home-manager configuration
    #       your-username = import ../home-manager/home.nix;
    #     };
    #   };
    #
    #   # To install home-manager globally
    #   environment.systemPackages =
    #     [ inputs.home-manager.packages.${pkgs.system}.default ];
    # }
  };
}
