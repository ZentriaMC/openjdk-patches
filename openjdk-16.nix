{ openjdk16 }:

openjdk16.overrideAttrs (old: {
  patches = old.patches ++ [
    ./0001-Set-min_pages-to-1-when-MaxHeapSize-is-equal-to-MinH.patch
    ./0002-Request-alternative-huge-page-size-explicitly-for-SH.patch
  ];
  dontStrip = true;
})
