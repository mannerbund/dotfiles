{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t480
    inputs.nixos-hardware.nixosModules.common-pc-laptop
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    ./hardware-configuration.nix
    ./hardware.nix

    ../common/core
    ../common/users/apostolic

    ../common/misc/bluetooth.nix
    ../common/misc/light.nix
    #../common/misc/gamemode.nix
    ../common/misc/wireguard.nix
    ../common/misc/zapret.nix
    ../common/misc/dnscrypt-proxy2.nix
    #../common/misc/scx.nix
  ];

  networking = {
    hostName = "chan";
    useNetworkd = true;
    nameservers = ["127.0.0.1"];
    firewall = {
      allowedTCPPorts = [53317 22000];
      allowedUDPPorts = [53317 22000];
    };
    useDHCP = false;
    wireless.iwd.enable = true;
  };

  services.resolved.enable = false;
  systemd.network = {
    enable = true;
    networks = {
      "10-wireless" = {
        name = "wlan0";
        DHCP = "yes";
        dhcpConfig.UseDNS = false;
      };
      "20-ethernet" = {
        name = "enp0s31f6";
        DHCP = "yes";
        dhcpConfig.UseDNS = false;
        linkConfig.RequiredForOnline = "no";
      };
    };
  };

  # Fix needed
  #systemd.tmpfiles.settings = {
  #  "10-iwd" = {
  #    "/var/lib/iwd/nevada.psk".C.argument = config.sops.secrets."wireless/home".path;
  #  };
  #};

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      vpl-gpu-rt
      intel-ocl
      intel-vaapi-driver
    ];
  };

  environment.systemPackages = with pkgs; [
    vim
  ];
  system.stateVersion = "24.11";
}
