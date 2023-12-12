{ config, pkgs, doom-emacs, vars, ... }:

{
  home-manager.users.${vars.user} = {
    imports = [ doom-emacs.hmModule ];

    programs.doom-emacs = {
      enable = true;
      doomPrivateDir = ./doom.d;
    };

    home.packages = with pkgs; [
      clang
      coreutils
      emacs
      fd
      git
      ripgrep
    ];
  };
}
