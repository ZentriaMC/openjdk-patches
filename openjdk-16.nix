{ openjdk16 }:

openjdk16.overrideAttrs (old: {
  patches = old.patches ++ [
    ./0001-Set-min_pages-to-1-when-MaxHeapSize-is-equal-to-MinH.patch
    ./0002-Request-alternative-huge-page-size-explicitly-for-SH.patch
    ./0003-Fix-hugetlbfs_sanity_check-not-using-MAP_HUGE_SHIFT.patch
  ];
  dontStrip = true;
})
