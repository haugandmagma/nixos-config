{ pkgs, vars, ... }:

{
  users.users.${vars.user} = {
    shell = pkgs.zsh;
    packages = with pkgs; [
      bat
      eza
      starship
      zsh-z
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
          "git"
          "z"
        ];
      };

      shellInit = ''
        source ${pkgs.starship}
        alias li='eza -lha --icons'
        alias lt='eza --tree --level=2 --long --icons'
        eval "$(starship init zsh)"
      '';
    };
  };
}
