let
  pkgs = import <nixpkgs> { };

in
  { throughput-benchmark = pkgs.haskellPackages.callPackage ./default.nix { };
  }
