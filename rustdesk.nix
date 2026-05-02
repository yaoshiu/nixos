{ ...  }: {
  services.rustdesk-server = {
    enable = true;
    openFirewall = true;
    signal.relayHosts = [ "23.159.248.67" ];
  };
}
