{ ... }:
{
  networking.proxy.default = "http://127.0.0.1:20122";
  networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
}
