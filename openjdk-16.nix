{ lib, openjdk16, fetchFromGitHub }:

let
  version = {
    feature = "16.0.1";
    build = "9";
  };
in
openjdk16.overrideAttrs (old: {
  version = "${version.feature}+${version.build}";

  src = fetchFromGitHub {
    owner = "openjdk";
    repo = "jdk${lib.versions.major version.feature}u";
    rev = "jdk-${version.feature}+${version.build}";
    sha256 = "1ggddsbsar4dj2fycfqqqagqil7prhb30afvq6933rz7pa9apm2f";
  };

  patches = old.patches ++ [
    ./0001-Set-min_pages-to-1-when-MaxHeapSize-is-equal-to-MinH.patch
    ./0002-Request-alternative-huge-page-size-explicitly-for-SH.patch
    ./0003-Fix-hugetlbfs_sanity_check-not-using-MAP_HUGE_SHIFT.patch
  ];
})
