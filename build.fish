#!/usr/bin/env fish

echo "compressing build results to separate zips"

pushd build

for d in (find . -type d -not -path ".")
  echo "see dir $d"
  zip -r "$d.zip" "$d"
end

popd
