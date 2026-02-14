{
  imports = [
    ./sing-box.nix
  ];
  sops = {
    defaultSopsFile = ./secrets/sing-box.yaml;
    age = {
      sshKeyPaths = [
        "/etc/ssh/ssh_host_ed25519_key"
      ];
      keyFile = "/var/lib/sops-nix/key.txt";
      generateKey = true;
    };
  };
}
