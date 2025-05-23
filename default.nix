# This file describes your repository contents.
# It should return a set of nix derivations
# and optionally the special attributes `lib`, `modules` and `overlays`.
# It should NOT import <nixpkgs>. Instead, you should take pkgs as an argument.
# Having pkgs default to <nixpkgs> is fine though, and it lets you use short
# commands such as:
#     nix-build -A mypackage

{
  pkgs ? import <nixpkgs> { },
}:

{
  # The `lib`, `modules`, and `overlays` names are special
  lib = import ./lib { inherit pkgs; }; # functions
  modules = import ./modules; # NixOS modules
  overlays = import ./overlays; # nixpkgs overlays

  olympus = pkgs.callPackage ./pkgs/olympus { };
  apostrophe-2-6-3 = pkgs.callPackage ./pkgs/apostrophe { };
  reqable = pkgs.callPackage ./pkgs/reqable { };
  sysmon = pkgs.callPackage ./pkgs/sysmon { };
  guile-lsp-server = pkgs.callPackage ./pkgs/guile-lsp-server { };
  libmks = pkgs.callPackage ./pkgs/libmks { };
  # some-qt5-package = pkgs.libsForQt5.callPackage ./pkgs/some-qt5-package { };
  # ...
}
