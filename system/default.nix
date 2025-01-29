{ pkgs, ... }:
{
  imports = [
    ./network
    ./nix
    ./users
  ];

  programs.fish.enable = true;

  environment.systemPackages = with pkgs; [
    wget
    gh
    wslu
  ];

  programs.nix-ld.enable = true;

  time.timeZone = "Asia/Shanghai";
}
