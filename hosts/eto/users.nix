{
  users.users.claude = {
    isNormalUser = true;
    home = "/home/claude";
    description = "Takafumi Asano";
    shell = "/run/current-system/sw/bin/elvish";
    extraGroups = [
      "wheel"
      "networkmanager"
      "docker"
      "libvirtd"
      "vboxusers"
      "plugdev" # For fingerprint scanner access
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICHtv7BugMwASTVv4+FZi3HlSke0cCNogLuTQQVm/aWc"
      # Biometric key for Terminus on the device "zoè"
      "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBA0Izr6fwz7d/QNd3sao8KW7ymotB/HOFkM9V/V44NGxR95tktSX0zlEGM5OSTsLp35qemH6ix5z29RzPowJVsg="
      # Biometric key for Terminus on the device "russell"
      "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBBj8Q6cfjjNjgL9rlMxNkffiS/YyHjtwulHQR+7/ugJhRRm+5i7hxlEmYVjK74IIPHfo9UrXVOxkmfaKgnIVDDU="
    ];
  };
}
