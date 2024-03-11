{
  # kickstarted from https://github.com/Misterio77/nix-starter-configs
  description = "NixOS configs";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    inherit (self) outputs;
    systems = [
      "aarch64-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    forAllSystems = nixpkgs.lib.genAttrs systems;

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
    # Your custom packages
    # Accessible through 'nix build', 'nix shell', etc
    packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});

    # Formatter for your nix files, available through 'nix fmt'
    # Other options beside 'alejandra' include 'nixpkgs-fmt'
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    # Your custom packages and modifications, exported as overlays
    overlays = import ./overlays {inherit inputs;};
    # Reusable nixos modules you might want to export
    # These are usually stuff you would upstream into nixpkgs
    nixosModules = import ./modules/nixos;
    # Reusable home-manager modules you might want to export
    # These are usually stuff you would upstream into home-manager
    homeManagerModules = import ./modules/home-manager;

    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#nixos'
    nixosConfigurations = {
      system = nixpkgs.lib.nixosSystem {
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
    };

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#user'
    homeConfigurations = {
      user = home-manager.lib.homeManagerConfiguration {
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
