{ lib, openjdk16, fetchFromGitHub, headless ? false }:

let
  version = {
    feature = "16.0.2";
    build = "7";
  };
in
(openjdk16.override { inherit headless; }).overrideAttrs (old: {
  version = "${version.feature}+${version.build}";

  src = fetchFromGitHub {
    owner = "openjdk";
    repo = "jdk${lib.versions.major version.feature}u";
    rev = "jdk-${version.feature}+${version.build}";
    sha256 = "sha256-/8XHNrf9joCCXMCyPncT54JhqlF+KBL7eAf8hUW/BxU=";
  };

  patches = old.patches ++ [
    ./16/0001-Set-min_pages-to-1-when-MaxHeapSize-is-equal-to-MinH.patch
    ./16/0002-Request-alternative-huge-page-size-explicitly-for-SH.patch
    ./16/0003-Fix-hugetlbfs_sanity_check-not-using-MAP_HUGE_SHIFT.patch
  ];
})
