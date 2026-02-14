{ config, ... }:
let
  domain = config.networking.fqdn;
in
{
  sops = {
    defaultSopsFile = ./secrets/sing-box.yaml;
    age = {
      sshKeyPaths = [
        "/etc/ssh/ssh_host_ed25519_key"
        "/home/runner/.ssh/id_ed25519"
      ];
      keyFile = "/var/lib/sops-nix/key.txt";
      generateKey = true;
    };
    secrets = {
      server_password = {
      };
      users_json = {
      };
    };

    templates."sing-box.json" = {
      owner = config.users.users.sing-box.name;
      group = config.users.groups.sing-box.name;
      mode = "0440";

      content = ''
        {
          "inbounds": [
            {
              "type": "shadowsocks",
              "listen": "::",
              "listen_port": 8080,
              "network": "tcp",
              "method": "2022-blake3-aes-128-gcm",
              "password": "${config.sops.placeholder.server_password}",
              "users": ${config.sops.placeholder.users_json},
              "multiplex": {
                "enabled": true
              }
            },
            {
              "type": "trojan",
              "listen": "::",
              "listen_port": 8081,
              "users": ${config.sops.placeholder.users_json},
              "tls": {
                "enabled": true,
                "server_name": "${domain}",
                "acme": {
                  "domain": "${domain}",
                  "email": "akafayash@icloud.com"
                }
              },
              "multiplex": {
                "enabled": true
              }
            },
            {
              "type": "hysteria2",
              "listen": "::",
              "listen_port": 8082,
              "up_mbps": 1000,
              "down_mbps": 1000,
              "users": ${config.sops.placeholder.users_json},
              "tls": {
                "enabled": true,
                "server_name": "${domain}",
                "acme": {
                  "domain": "${domain}",
                  "email": "akafayash@icloud.com"
                }
              }
            }
          ],
          "experimental": {
            "clash_api": {
              "external_controller": "127.0.0.1:9090",
              "secret": "fayash",
              "access_control_allow_private_network": true
            }
          }
        }
      '';
    };
  };
}
