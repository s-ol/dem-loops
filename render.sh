#!/bin/sh

export MAGICK_TMPDIR="."

render() {
  loop=`basename $1 .moon`
  if [[ $loop == "demoloop" ]]; then
    continue
  fi
  out=`love . --render --fps 30 --no_overwrite 1 "${@:2}" $loop`
  echo retrieving files from $out
  wd=`pwd`
  pushd $out &> /dev/null # apparently having the filenames long breaks stuff?
  convert -limit Area 2GiB -limit Map 2GiB -limit Memory 1GiB -limit Thread 5 -delay 3 -dispose Background *.png $wd/gifs/$loop.gif
  popd &> /dev/null
  echo rendered gifs/$loop.gif
}

if [[ $1 == "all" ]]; then
  for loop in *.moon; do
    render `basename $loop .moon`
  done
elif [[ -n $1 ]]; then
  render "$@"
else
  echo "usage: '$(basename $0) <loop>' or '$(basename $0) all'"
  exit 1
fi
