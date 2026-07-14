let
  # Fetch the unstable channel to match your previous flake setup
  pkgs = import (builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz") {};

  # Fetch the main Nixvim repository
  nixvim = import (builtins.fetchTarball "https://github.com/nix-community/nixvim/archive/main.tar.gz");
in
nixvim.legacyPackages.${pkgs.system}.makeNixvimWithModule {
  inherit pkgs;
  module = ./nixvim.nix;
}
