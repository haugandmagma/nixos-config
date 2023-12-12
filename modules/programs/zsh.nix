{ pkgs, vars, ... }:

{
users.users.${vars.user} = {
    shell = pkgs.zsh;
    packages = [ pkgs.starship ];
  };

  programs = {
    starship = {
      enable = true;
    };
    zsh = {
      enable = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
      enableCompletion = true;
      histSize = 100000;

      ohMyZsh = {
        enable = true;
        plugins = [ "git" ];
      };

      shellInit = ''
        source ${pkgs.starship}
        eval "$(starship init zsh)"
      '';
    };
  };
}
