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

      bootMode = "uefi"; # uefi or bios
      bootMountPath = "/boot"; # mount path for efi boot partition; only used for uefi boot mode
      grubDevice = ""; # device identifier for grub; only used for legacy (bios) boot mode
    };

    userSettings = {
      username = "a2not";
      name = "a2not";
      email = "a2not.dev@gmail.com";

      editor = "neovim";
    };

    supportedSystems = ["x86_64-linux" "aarch64-linux"];
    # Function to generate a set based on supported systems:
    forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    # Attribute set of nixpkgs for each system:
    nixpkgsFor =
      forAllSystems (system: import inputs.nixpkgs {inherit system;});
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

    # install script
    packages = forAllSystems (system: let
      pkgs = nixpkgsFor.${system};
    in {
      default = self.packages.${system}.install;

      install = pkgs.writeShellApplication {
        name = "install";
        runtimeInputs = with pkgs; [git neovim];
        text = ''${./scripts/install.sh} "$@"'';
      };
    });

    apps = forAllSystems (system: {
      default = self.apps.${system}.install;

      install = {
        type = "app";
        program = "${self.packages.${system}.install}/bin/install";
      };
    });
  };
}
