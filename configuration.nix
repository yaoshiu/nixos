{ modulesPath, ... }:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        xbootldrMountPoint = "/boot";
      };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/efi";
      };
    };

    kernel.sysctl = {
      "net.core.default_qdisc" = "fq";
      "net.ipv4.tcp_congestion_control" = "bbr";
    };
  };

  zramSwap.enable = true;

  networking = {
    hostName = "zgo-la";
    domain = "fayash.me";
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
    firewall = {
      enable = true;
      allowedTCPPorts = [
        80
        443
      ];
    };
  };

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "prohibit-password";
    };
  };

  services.fail2ban = {
    enable = true;
    bantime = "1h";
  };

  users.users.root = {
    initialPassword = "initial";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID4tUJIE/YKZQTSbbewzv37957T9X6aNcvKlxDoWcALO huangyifei@MAGIT04390.local"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINNLLm6m7F59XdbsiAblXyOz15kGNBmZKQ+7VoIYHm8V huangyifei@MAGIT04390.local"
    ];
  };

  system.stateVersion = "25.11";
}
