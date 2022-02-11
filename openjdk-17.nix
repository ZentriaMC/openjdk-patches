{ lib, openjdk17, fetchFromGitHub, headless ? false }:

let
  version = {
    feature = "17";
    interim = ".0.1";
    build = "12";
  };
in
(openjdk17.override { inherit headless; }).overrideAttrs (old: {
  version = "${version.feature}${version.interim}+${version.build}";

  src = fetchFromGitHub {
    owner = "openjdk";
    repo = "jdk${version.feature}u";
    rev = "jdk-${version.feature}${version.interim}+${version.build}";
    sha256 = "1l1jgbz8q7zq66npfg88r0l5xga427vrz35iys09j44b6qllrldd";
  };

  patches = old.patches ++ [
    ./17/0002-Request-alternative-huge-page-size-explicitly-for-SH.patch
  ];
})
