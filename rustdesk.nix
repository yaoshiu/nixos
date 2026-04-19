{ ...  }: {
  services.rustdesk-server = {
    enable = true;
    openFirewall = true;
    signal.relayHosts = [ "zgo-la.fayash.me" ];
  };
}
