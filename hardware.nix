{ pkgs, ... }:
{
  hardware = {
    ledger.enable = true;
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        mesa
      ];
    };
    bluetooth.enable = true;
    xone.enable = true;
    nvidia = {
      open = true;
      modesetting.enable = true;
    };
    nvidia-container-toolkit.enable = true;
  };
}
