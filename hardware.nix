{ config, ... }:
{
  hardware = {
    ledger.enable = true;
    graphics.enable32Bit = true;
    bluetooth.enable = true;
    xone.enable = true;
    nvidia.open = true;
  };
}
