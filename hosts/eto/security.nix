{
  security.pam = {
    loginLimits = [
      {
        domain = "*";
        type = "soft";
        item = "nofile";
        value = "unlimited";
      }
    ];
    services.login.enableGnomeKeyring = true;
  };
}
