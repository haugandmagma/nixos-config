{ pkgs, vars, ... }:

{
  services = {
    tlp.enable = true;
    auto-cpufreq.enable = true;
  };

  home-manager.users.${vars.user} = {
    services = {
      cbatticon = {
        enable = true;
        criticalLevelPercent = 10;
        commandCriticalLevel = ''notify-send "battery critical!"'';
        lowLevelPercent = 30;
        iconType = "standard";
      };
    };
  };
}
