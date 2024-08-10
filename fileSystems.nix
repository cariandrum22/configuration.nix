{
  fileSystems."/mnt/magnetic/disk0" = {
    device = "/dev/sda1";
    fsType = "ntfs";
    options = [ "rw" ];
  };

  fileSystems."/mnt/windows/disk0" = {
    device = "/dev/nvme1n1p4";
    fsType = "ntfs";
    options = [ "rw" ];
  };
}
