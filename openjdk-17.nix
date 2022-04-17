{ lib, openjdk17, fetchFromGitHub, headless ? false }:

let
  version = {
    feature = "17";
    interim = ".0.3";
    build = "1";
  };
in
(openjdk17.override { inherit headless; }).overrideAttrs (old: {
  version = "${version.feature}${version.interim}+${version.build}";

  src = fetchFromGitHub {
    owner = "openjdk";
    repo = "jdk${version.feature}u";
    rev = "jdk-${version.feature}${version.interim}+${version.build}";
    sha256 = "sha256-QZW+rKH0YbidpMIKRenYWRglMsPh+53vUS1Qz3HB6Ek=";
  };

  configureFlags = old.configureFlags ++ [
    "--with-version-build=${version.build}"
    "--with-version-opt=zentria"
  ];

  patches = old.patches ++ [
    ./17/0002-Request-alternative-huge-page-size-explicitly-for-SH.patch
  ];
})
