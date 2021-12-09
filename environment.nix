{ pkgs, ... }:

{
  environment.shellInit = ''
    export SSH_ASKPASS="${pkgs.gnome3.seahorse}/libexec/seahorse/ssh-askpass"
  '';
}
