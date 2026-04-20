{
  # chetter is administered via SSH keys on AWS, so wheel users need
  # passwordless sudo unless a local password is managed separately.
  security.sudo.wheelNeedsPassword = false;

  security.pam.loginLimits = [
    {
      domain = "*";
      type = "soft";
      item = "nofile";
      value = "unlimited";
    }
  ];
}
