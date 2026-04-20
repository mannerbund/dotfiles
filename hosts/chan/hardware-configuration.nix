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
              label = "luks";
              size = "100%";
              content = {
                type = "luks";
                name = "crypted";
                content = {
                  type = "btrfs";
                  extraArgs = [ "-f" ];
                  subvolumes = {
                    "/root" = {
                      mountpoint = "/";
                      mountOptions = [
                        "compress=zstd"
                        "noatime"
                        "ssd"
                        "discard=async"
                      ];
                    };
                    "/nix" = {
                      mountpoint = "/nix";
                      mountOptions = [
                        "compress=zstd"
                        "noatime"
                        "ssd"
                        "discard=async"
                      ];
                    };
                    "/persist" = {
                      mountpoint = "/persist";
                      mountOptions = [
                        "compress=zstd"
                        "noatime"
                        "ssd"
                        "discard=async"
                      ];
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
  };

  fileSystems."/persist".neededForBoot = true;

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = [ "kvm-intel" ];
    loader = {
      systemd-boot = {
        enable = true;
        consoleMode = "max";
      };
      efi.canTouchEfiVariables = true;
      systemd-boot.configurationLimit = 8;
    };
    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "nvme"
      ];
      systemd = {
        enable = true;
        extraBin = {
          "mkdir" = "${pkgs.coreutils}/bin/mkdir";
          "date" = "${pkgs.coreutils}/bin/date";
          "stat" = "${pkgs.coreutils}/bin/stat";
          "mv" = "${pkgs.coreutils}/bin/mv";
          "find" = "${pkgs.findutils}/bin/find";
          "btrfs" = "${pkgs.btrfs-progs}/bin/btrfs";
          "cut" = "${pkgs.coreutils}/bin/cut";
        };
        packages = with pkgs; [
          btrfs-progs
          coreutils
          findutils
          gawk
          util-linux
        ];

        services.impermanence = {
          description = "Reset root subvolume for impermanence";
          unitConfig.DefaultDependencies = false;
          serviceConfig.Type = "oneshot";
          wantedBy = [ "initrd.target" ];
          before = [ "sysroot.mount" ];

          requires = [ "initrd-root-device.target" ];
          after = [
            "initrd-root-device.target"
          ];

          script = ''
            set -euo pipefail

            mkdir -p /btrfs_tmp
            mount /dev/mapper/crypted /btrfs_tmp
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
        };
      };
    };
  };
}
