{
  config,
  inputs,
  lib,
  pkgs,
  self,
  ...
}:

{
  imports = [
    (import ./neovim.nix {
      inherit
        config
        inputs
        lib
        pkgs
        self
        ;
    })

    (import ./notes.nix { inherit pkgs; })

    (import ./tmux-sessionizer.nix {
      inherit
        config
        lib
        pkgs
        self
        ;
    })

    ./bin.nix
    ./direnv.nix
    ./fzf.nix
    ./git.nix
    ./phpactor.nix
    ./ripgrep.nix
    ./starship.nix
    ./syncthing.nix
    ./tmux.nix
    ./zsh.nix
  ];
}
