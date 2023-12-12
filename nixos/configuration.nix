# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, lib, pkgs, stable, inputs, vars, ... }:
let
  terminal = pkgs.${vars.terminal};
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ] ++
    ( import ../modules/programs ) ++
    ( import ../modules/services ) ++
    ( import ../modules/services/desktops );

  # Use the systemd-boot EFI boot loader.
  boot = {
    loader ={
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages_latest;
  };

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
  };

  # Set your time zone.
  time.timeZone = "Asia/Jakarta";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    #keyMap = "us";
    useXkbConfig = true; # use xkbOptions in tty.
  };

  security = {
    polkit.enable = true;
    rtkit.enable = true;
    sudo.wheelNeedsPassword = false;
  };

  services = {
    printing = {
      enable = true;
    };
    pipewire = {
      enable = true;
      alsa = {
	      enable = true;
	      support32Bit = true;
      };
      pulse.enable = true;
      jack.enable = true;
    };
    openssh = {
      enable = true;
      allowSFTP = true;
      # extraConfig = ''
      #   HostKeyAlgorithms +ssa-rsa
      # '';
    };
  };

  hardware = {
    pulseaudio = {
      enable = false;
    };
    opengl = {
      enable = true;
      extraPackages = with pkgs; [
	      intel-media-driver
	      vaapiIntel
	      vaapiVdpau
	      libvdpau-va-gl
      ];
    };
    sane = {
      enable = true;
      extraBackends = [ pkgs.sane-airscan ];
    };
    bluetooth = {
      enable = true;
    };
  };

  # Enable sound.
  sound.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${vars.user} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.
  };

  fonts.packages = with pkgs; [
    carlito
    vegur
    source-code-pro
    jetbrains-mono
    meslo-lgs-nf
    monocraft
    font-awesome
    corefonts
    (nerdfonts.override {
      fonts = [
	"FiraCode"
      ];
    })
  ];

  environment = {
    variables = {
      TERMINAL = "${vars.terminal}";
      EDITOR = "${vars.editor}";
      VISUAL = "${vars.editor}";
    };
    systemPackages = with pkgs; [
      # Terminal
      awscli2
      bat
      btop
      coreutils
      eza
      git
      killall
      kubectl
      lshw
      nano
      netcat
      nix-tree
      pciutils
      ranger
      terminal
      tldr
      usbutils
      wget

      # Apps
      appimage-run
      dbeaver
      librewolf
      onlyoffice-bin
      telegram-desktop

      # Video/Audio
      feh
      mpv
      pavucontrol
      vlc
      spotify

      # File Management
      gnome.file-roller
      okular
      #pcmanfm
      p7zip
      rsync
      unzip
      unrar
      zip
    ] ++
    (with pkgs; [
      # Apps
      firefox

      # Video/Audio
      alsa-utils
      pipewire
      pulseaudio
    ]);
  };

  programs = {
    dconf.enable = true;
  };

  nix = {
    settings = {
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 2d";
    };
    package = pkgs.nixVersions.unstable;
    registry.nixpkgs.flake = inputs.nixpkgs;
    extraOptions = ''
      experimental-features	= nix-command flakes
      keep-outputs		= true
      keep-derivations		= true
    '';
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
      permittedInsecurePackages = [ "openssl-1.1.1w" ];
    };
  };

  systemd.tmpfiles.rules = [ "d /var/lib/bluetooth 700 root root - -" ];
  systemd.targets."bluetooth".after = [ "systemd-tmpfiles-setup.service" ];

  system.stateVersion = "23.05";

  home-manager.users.${vars.user} = {
    home = {
      stateVersion = "23.05";
    };
    programs = {
      home-manager.enable = true;
    };
  };
}
