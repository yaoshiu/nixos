{ ... }:
{
  users.users.yaoshiu = {
    isNormalUser = true;
    description = "Fay Ash";
    initialPassword = "123456";
    extraGroups = [ "wheel" ];
  };

  wsl.defaultUser = "yaoshiu";
}
