{ ... }: {
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

  services.openssh.enable = true;

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID4tUJIE/YKZQTSbbewzv37957T9X6aNcvKlxDoWcALO huangyifei@MAGIT04390.local"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINNLLm6m7F59XdbsiAblXyOz15kGNBmZKQ+7VoIYHm8V huangyifei@MAGIT04390.local"
  ];

  system.stateVersion = "25.11";
}
