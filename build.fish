#!/usr/bin/env fish

echo "compressing build results to separate zips"

pushd build

for d in web linux windows
  echo "see dir $d"
  zip -r "$d.zip" "$d"
end

popd
