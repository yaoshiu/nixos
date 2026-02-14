{ lib, config, ... }:
let
  domain = config.networking.fqdn;
in
{
  sops.secrets = {
    server_password = {
      owner = config.users.users.sing-box.name;
      group = config.users.groups.sing-box.name;
    };
    users_json = {
      owner = config.users.users.sing-box.name;
      group = config.users.groups.sing-box.name;
    };
  };

  networking = {
    firewall = {
      allowedTCPPorts = [
        8080
        8081
        8082
      ];
      allowedUDPPorts = [
        8080
        8081
        8082
      ];
      allowedUDPPortRanges = [
        {
          from = 20000;
          to = 50000;
        }
      ];
    };
    nat = {
      enable = lib.mkDefault true;
      externalInterface = "eth0";
      forwardPorts = [
        {
          destination = "127.0.0.1:8082";
          sourcePort = "20000:50000";
          proto = "udp";
        }
      ];
    };
  };

  services.sing-box = {
    enable = true;
    settings = {
      log = {
        level = "info";
        timestamp = true;
      };

      inbounds = [
        # === Shadowsocks ===
        {
          type = "shadowsocks";
          listen = "::";
          listen_port = 8080;
          network = "tcp";
          method = "2022-blake3-aes-128-gcm";

          # 使用 _secret 语法指向解密后的文件路径
          password = {
            _secret = config.sops.secrets.server_password.path;
          };
          users = {
            _secret = config.sops.secrets.users_json.path;
            quote = false;
          };

          multiplex.enabled = true;
        }

        # === Trojan ===
        {
          type = "trojan";
          listen = "::";
          listen_port = 8081;

          users = {
            _secret = config.sops.secrets.users_json.path;
            quote = false;
          };

          tls = {
            enabled = true;
            server_name = domain;
            acme = {
              domain = domain;
              email = "akafayash@icloud.com";
            };
          };
          multiplex.enabled = true;
        }

        # === Hysteria2 ===
        {
          type = "hysteria2";
          listen = "::";
          listen_port = 8082;
          up_mbps = 1000;
          down_mbps = 1000;

          users = {
            _secret = config.sops.secrets.users_json.path;
            quote = false;
          };

          tls = {
            enabled = true;
            server_name = domain;
            acme = {
              domain = domain;
              email = "akafayash@icloud.com";
            };
          };
        }
      ];

      experimental = {
        clash_api = {
          external_controller = "127.0.0.1:9090";
          secret = "fayash";
          access_control_allow_private_network = true;
        };
      };
    };
  };

  systemd.services.sing-box = {
    serviceConfig = {
      AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
      CapabilityBoundingSet = [ "CAP_NET_BIND_SERVICE" ];
    };
  };

  boot.kernel.sysctl = {
    "net.core.rmem_max" = 8000000;
    "net.core.wmem_max" = 8000000;
  };
}
