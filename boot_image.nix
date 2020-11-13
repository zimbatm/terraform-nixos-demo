{ modulesPath, ... }:
{
  imports = [
    "${modulesPath}/profiles/minimal.nix"
    "${modulesPath}/virtualisation/google-compute-image.nix"
  ];

  # Enable the OpenSSH daemon
  services.openssh.enable = true;
  services.openssh.passwordAuthentication = false;

  # Add your admins SSH keys here. TODO: improve this
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDGB1Pog97SWdV2UEA40V+3bML+lSZXEd48zCRlS/eGbY3rsXfgUXb5FIBulN9cET9g0OOAKeCZBR1Y2xXofiHDYkhk298rHDuir6cINuoMGUO7VsygUfKguBy63QMPHYnJBE1h+6sQGu/3X9G2o/0Ys2J+lZv4+N7Hqolhbg/Cu6/LUCsJM/udqTVwJGEqszDWPtuuTAIS6utB1QdL9EZT5WBb1nsNyHnIlCnoDKZvrrO9kM0FGKhjJG2skd3+NqmLhYIDhRhZvRnL9c8U8uozjbtj/N8L/2VCRzgzKmvu0Y1cZMWeAAdyqG6LoyE7xGO+SF4Vz1x6JjS9VxnZipIB zimbatm@nixos"
  ];
}
