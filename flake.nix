{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/release-23.05";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixgl = {
      url = "github:guibou/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:pjones/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "nixpkgs";
    };
  }; 

  outputs = inputs @ { self, nixpkgs, nixpkgs-stable, home-manager, nixgl, nixvim, plasma-manager, ... }:
  let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };

    stable = import nixpkgs-stable {
      inherit system;
      config.allowUnfree = true;
    };

    vars = {
      user = "muhamad";
      location = "$HOME/.setup";
      terminal = "wezterm";
      editor = "nvim";
    };

    lib = nixpkgs.lib;
  in
  {
    nixosConfigurations = {
      nixos = lib.nixosSystem {
	inherit system;
	specialArgs = { inherit inputs system stable plasma-manager vars; };
	modules = [
	  nixvim.nixosModules.nixvim
	  ./nixos/configuration.nix

	  home-manager.nixosModules.home-manager {
	    home-manager.useGlobalPkgs = true;
	    home-manager.useUserPackages = true;
	  }
	];
      };
    };
  };
}
