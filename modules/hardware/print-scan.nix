{ pkgs, ... }:

{
  services = {
    printing.enable = true;
  };

  hardware = {
    sane = {
      enable = true;
      extraBackends = [ pkgs.sane-airscan ];
    };
  };

  # environment.systemPackages = [
  #   pkgs.simple-scan
  # ];
}
