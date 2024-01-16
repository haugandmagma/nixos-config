{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    strongswan
    openfortivpn
  ];
  services.strongswan = {
    enable = true;
    secrets = [
      "ipsec.d/ipsec.nm-l2tp.secrets"
    ];
  };
}
