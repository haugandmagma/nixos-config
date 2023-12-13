{ pkgs, ... }:

{
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
