{ config, lib, pkgs, ... }:

{
  ## Imports
  imports = [
    ./hardware-configuration.nix
  ];

  ## Boot
  boot = {
    consoleLogLevel = 3;
    initrd.verbose = false;
    kernelPackages = pkgs.linuxPackages_latest;

    kernelParams = [
      "quiet"
      "systemd.show_status=auto"
      "udev.log_level=3"
    ];

    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
      timeout = 0;
    };

    plymouth.enable = true;
  };

  ## Environment
  environment.systemPackages = with pkgs; [
    discord
    distrobox
    distroshelf
    dnsmasq
    easyeffects
    git
    github-desktop
    gnome-boxes
    google-chrome
    hunspell
    jetbrains-toolbox
    kdePackages.audiotube
    kdePackages.kdenlive
    kdePackages.merkuro
    libreoffice-qt6-fresh
    nodejs
    obs-studio
    openrazer-daemon
    papers
    polychromatic
    prismlauncher
    vscode
    zapzap
  ];

  ## Hardware
  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;

      settings = {
        General = {
          Experimental = true;
          FastConnectable = true;
        };

        Policy.AutoEnable = true;
      };
    };

    enableRedistributableFirmware = true;
    graphics.enable = true;
    openrazer.enable = true;

    nvidia = {
      modesetting.enable = true;
      nvidiaSettings = true;
      open = true;

      package =
        config.boot.kernelPackages.nvidiaPackages.beta;

      powerManagement = {
        enable = true;
        finegrained = false;
      };
    };
  };

  ## Internationalisation
  i18n.defaultLocale = "en_US.UTF-8";

  ## Networking
  networking = {
    firewall = {
      enable = true;
      trustedInterfaces = [ "virbr0" ];
    };
    hostName = "nixos";
    networkmanager.enable = true;
  };

  ## Nixpkgs
  nixpkgs.config.allowUnfree = true;

  ## Programs
  programs = {
    appimage = {
      binfmt = true;
      enable = true;
    };

    firefox.enable = true;
    java.enable = true;
    kdeconnect.enable = true;

    steam = {
      dedicatedServer.openFirewall = true;
      enable = true;
      extraPackages = [ pkgs.jdk ];
      localNetworkGameTransfers.openFirewall = true;
      remotePlay.openFirewall = true;
    };

    virt-manager.enable = true;
  };

  ## Security
  security = {
    rtkit.enable = true;
  };

  ## Services
  services = {
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    desktopManager.plasma6.enable = true;

    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };

    flatpak.enable = true;

    openssh.enable = true;

    pipewire = {
      alsa = {
        enable = true;
        support32Bit = true;
      };

      enable = true;
      jack.enable = true;
      pulse.enable = true;
    };

    printing = {
      drivers = [ pkgs.hplip ];
      enable = true;
    };

    xserver.videoDrivers = [ "nvidia" ];
  };

  ## System
  system = {
    copySystemConfiguration = true;
    stateVersion = "26.05";
  };

  ## Time
  time.timeZone = "Asia/Kolkata";

  ## Users
  users.users.megh = {
    extraGroups = [ "openrazer" "wheel" "podman" "libvirtd"];
    isNormalUser = true;
    packages = with pkgs; [ ];
  };

  ## Virtualisation
  virtualisation = {
    containers.enable = true;
    libvirtd = {
      enable = true;
      qemu.vhostUserPackages = with pkgs; [ virtiofsd ];
    };
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };
}
