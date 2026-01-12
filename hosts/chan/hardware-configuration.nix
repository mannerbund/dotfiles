{
  inputs,
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    inputs.impermanence.nixosModules.impermanence
    inputs.disko.nixosModules.disko
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t480
  ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "nvme"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  boot.loader = {
    systemd-boot = {
      enable = true;
      consoleMode = "max";
    };
    efi.canTouchEfiVariables = true;
    systemd-boot.configurationLimit = 8;
  };

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp0s31f6.useDHCP = lib.mkDefault true;
  # networking.interfaces.wg0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlan0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings.General = {
        ControllerMode = "bredr";
        Experimental = true;
      };
    };
    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 100;
  };

  services = {
    upower.enable = true;
    libinput = {
      enable = true;
      mouse.accelProfile = "flat";
    };
  };

  # impermanence + disko
  environment.persistence."/persist" = {
    directories = [
      "/var"
    ];
    files = [ "/etc/machine-id" ];
  };

  programs.fuse.userAllowOther = true;

  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/disk/by-path/pci-0000:3d:00.0-nvme-1";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "crypted";
                content = {
                  type = "lvm_pv";
                  vg = "root_vg";
                };
              };
            };
          };
        };
      };
    };

    lvm_vg = {
      root_vg = {
        type = "lvm_vg";
        lvs = {
          root = {
            size = "100%FREE";
            content = {
              type = "btrfs";
              extraArgs = [ "-f" ];
              subvolumes = {
                "/root" = {
                  mountOptions = [
                    "subvol=root"
                    "compress=zstd"
                    "noatime"
                  ];
                  mountpoint = "/";
                };
                "/nix" = {
                  mountOptions = [
                    "subvol=nix"
                    "compress=zstd"
                    "noatime"
                  ];
                  mountpoint = "/nix";
                };
                "/persist" = {
                  mountOptions = [
                    "subvol=persist"
                    "compress=zstd"
                    "noatime"
                  ];
                  mountpoint = "/persist";
                };
              };
            };
          };
        };
      };
    };
  };

  fileSystems."/persist".neededForBoot = true;

  boot.initrd.postResumeCommands = lib.mkAfter ''
    mkdir /btrfs_tmp
    mount /dev/root_vg/root /btrfs_tmp
    if [[ -e /btrfs_tmp/root ]]; then
        mkdir -p /btrfs_tmp/old_roots
        timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
        mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
    fi

    delete_subvolume_recursively() {
        IFS=$'\n'
        for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
            delete_subvolume_recursively "/btrfs_tmp/$i"
        done
        btrfs subvolume delete "$1"
    }

    for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
        delete_subvolume_recursively "$i"
    done

    btrfs subvolume create /btrfs_tmp/root
    umount /btrfs_tmp
  '';
}
