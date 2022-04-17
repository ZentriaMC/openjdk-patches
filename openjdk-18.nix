{ lib, openjdk17, fetchFromGitHub, fetchurl, headless ? false, nixpkgs }:

let
  version = {
    feature = "18";
    interim = "";
    build = "37";
  };
in
(openjdk17.override {
  inherit headless;
  openjdk17-bootstrap = openjdk17.override { headless = true; };
}).overrideAttrs (old: {
  version = "${version.feature}${version.interim}+${version.build}";

  src = fetchFromGitHub {
    owner = "openjdk";
    repo = "jdk${version.feature}u";
    rev = "jdk-${version.feature}${version.interim}+${version.build}";
    sha256 = "sha256-yGPC8VA983Ml6Fv/oiEgRrcVe4oe+Q4oCHbzOmFbZq8=";
  };

  # Cannot use old.patches, as some of them do not apply.
  patches = [
    "${nixpkgs}/pkgs/development/compilers/openjdk/fix-java-home-jdk10.patch"
    "${nixpkgs}/pkgs/development/compilers/openjdk/read-truststore-from-env-jdk10.patch"
    "${nixpkgs}/pkgs/development/compilers/openjdk/currency-date-range-jdk10.patch"
    "${nixpkgs}/pkgs/development/compilers/openjdk/increase-javadoc-heap-jdk13.patch"
    #"${nixpkgs}/pkgs/development/compilers/openjdk/ignore-LegalNoticeFilePlugin.patch" # does not apply

    # -Wformat etc. are stricter in newer gccs, per
    # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=79677
    # so grab the work-around from
    # https://src.fedoraproject.org/rpms/java-openjdk/pull-request/24
    (fetchurl {
      url = "https://src.fedoraproject.org/rpms/java-openjdk/raw/06c001c7d87f2e9fe4fedeef2d993bcd5d7afa2a/f/rh1673833-remove_removal_of_wformat_during_test_compilation.patch";
      sha256 = "082lmc30x64x583vqq00c8y0wqih3y4r0mp1c4bqq36l22qv6b6r";
    })
  ] ++ lib.optionals (!headless && old.enableGnome2) [
    "${nixpkgs}/pkgs/development/compilers/openjdk/swing-use-gtk-jdk13.patch"
  ] ++ [
    ./17/0002-Request-alternative-huge-page-size-explicitly-for-SH.patch
  ];
})
