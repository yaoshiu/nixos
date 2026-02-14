{ config, ... }:
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
            quote = true;
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
            quote = true;
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
            quote = true;
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
}
