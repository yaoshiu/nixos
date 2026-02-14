{ config, ... }: {
  imports = [
    ./sops.nix
  ];
  services.sing-box = {
    enable = true;
    settings = {
      _secret = config.sops.templates."sing-box.json".path;
    };
  };
}
