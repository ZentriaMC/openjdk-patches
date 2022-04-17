{
  description = "OpenJDK";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    let
      supportedSystems = [
        "aarch64-linux"
        "x86_64-linux"
      ];
    in
    flake-utils.lib.eachSystem supportedSystems (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      rec {
        packages.openjdk-16 = pkgs.callPackage ./openjdk-16.nix {
          inherit (pkgs.javaPackages.compiler) openjdk16;
        };
        packages.openjdk-headless-16 = self.packages.${system}.openjdk-16.override {
          headless = true;
        };

        packages.openjdk-17 = pkgs.callPackage ./openjdk-17.nix {
          inherit (pkgs.javaPackages.compiler) openjdk17;
        };
        packages.openjdk-headless-17 = self.packages.${system}.openjdk-17.override {
          headless = true;
        };

        packages.openjdk-18 = pkgs.callPackage ./openjdk-18.nix {
          inherit (pkgs.javaPackages.compiler) openjdk17;
          inherit nixpkgs;
        };
        packages.openjdk-headless-18 = self.packages.${system}.openjdk-18.override {
          headless = true;
        };
      });
}
