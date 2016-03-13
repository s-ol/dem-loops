#!/bin/sh
for loop in *.moon; do
  loop=`basename $loop .moon`
  if [[ $loop == "demoloop" ]]; then
    continue
  fi
  out=`love . --render --overwrite 1 --fps 30 "$@" $loop`
  wd=`pwd`
  pushd $out &> /dev/null # apparently having the filenames long breaks stuff?
  convert -limit Area 2GiB -limit Map 2GiB -limit Memory 1GiB -delay 3 *.png $wd/gifs/$loop.gif
  popd &> /dev/null
  echo rendered gifs/$loop.gif
done
