{ openjdk16 }:

openjdk16.overrideAttrs (old: {
  patches = old.patches ++ [
    ./0001-Set-min_pages-to-1-when-MaxHeapSize-is-equal-to-MinH.patch
    ./0002-Ask-for-1-GB-hugetlb-page-size-explicitly.patch
  ];
  dontStrip = true;
})
