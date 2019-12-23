{
  users.users.claude = {
    isNormalUser = true;
    home = "/home/claude";
    description = "Takafumi Asano";
    shell = "/run/current-system/sw/bin/fish";
    extraGroups = [ "wheel" "networkmanager" "docker" "libvirtd" "vboxusers"];
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICHtv7BugMwASTVv4+FZi3HlSke0cCNogLuTQQVm/aWc" ];
  };
}
