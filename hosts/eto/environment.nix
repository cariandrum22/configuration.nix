{ pkgs, ... }:

{
  environment.shellInit = ''
    export SSH_ASKPASS="${pkgs.seahorse}/libexec/seahorse/ssh-askpass"
  '';
}
