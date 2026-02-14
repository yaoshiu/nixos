{ modulesPath, ... }:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  boot.loader = {
    systemd-boot = {
      enable = true;
      xbootldrMountPoint = "/boot";
    };
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/efi";
    };
  };

  networking = {
    hostName = "zgo-la";
    interfaces.eth0 = {
      ipv4.addresses = [
        {
          address = "23.159.248.67";
          prefixLength = 24;
        }
      ];
    };
    defaultGateway = "23.159.248.1";
    nameservers = [
      "1.1.1.1"
      "8.8.8.8"
    ];
  };

  services.openssh.enable = true;

  users.users.root = {
    initialPassword = "initial";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID4tUJIE/YKZQTSbbewzv37957T9X6aNcvKlxDoWcALO huangyifei@MAGIT04390.local"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINNLLm6m7F59XdbsiAblXyOz15kGNBmZKQ+7VoIYHm8V huangyifei@MAGIT04390.local"
    ];
  };

  system.stateVersion = "25.11";
}
