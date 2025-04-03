{
  inputs,
  pkgs,
  config,
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

    ../common/optional/bluetooth.nix
    ../common/optional/dnscrypt-proxy2.nix
    ../common/optional/zapret.nix
    #../common/optional/wireguard.nix
    ../common/optional/light.nix
    ../common/optional/gamemode.nix
    ../common/optional/scx.nix
  ];

  networking = {
    hostName = "chan";
    useNetworkd = true;
    nameservers = ["127.0.0.1" "::1"];
    dhcpcd.extraConfig = "nohook resolv.conf";
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
        linkConfig.RequiredForOnline = "routable";
      };
      "20-ethernet" = {
        name = "enp0s31f6";
        DHCP = "yes";
        linkConfig.RequiredForOnline = "no";
      };
    };
  };

  # Need fix
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
