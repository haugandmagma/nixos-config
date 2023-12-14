{ pkgs, vars, ... }:

{
  users.users.${vars.user} = {
    shell = pkgs.zsh;
    packages = with pkgs; [
      bat
      eza
      starship
    ];
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
        plugins = [
          "aliases"
          "git"
          "z"
        ];
      };

      shellInit = ''
        source ${pkgs.starship}
        alias ll='eza -l --icons -a'
        alias lt='eza -tree --level=2 --long --icons'
        eval "$(starship init zsh)"
      '';
    };
  };
}
