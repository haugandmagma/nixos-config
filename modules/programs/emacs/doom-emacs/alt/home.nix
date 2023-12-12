{ config, pkgs, vars, ... }:

{
  home-manager.users.${vars.user} = {
    home = {
      file.".doom.d" = {
        source = ./doom.d;
        recursive = true;
        onChange = builtins.readFile ./doom.sh;
      };

      packages = with pkgs; [
        alacritty
        ripgrep
        coreutils
        fd
      ];
    };

    programs.emacs.enable = true;
  };
}
