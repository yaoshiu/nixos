{ config, ... }: {
  imports = [
    ./sops.nix
  ];
  services.sing-box = {
    enable = true;
    settings = {
      _secrets = config.sops.templates."sing-box.json".path;
    };
  };
}
