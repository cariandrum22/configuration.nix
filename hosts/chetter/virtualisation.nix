{ pkgs, ... }:

{
  virtualisation = {
    docker = {
      enable = true;
      package = pkgs.docker_29;
    };
    libvirtd.enable = true;
  };
}
