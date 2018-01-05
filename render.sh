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
  convert -delay 3 -dispose Background *.png $wd/gifs/$loop.gif
  ffmpeg -y -v warning -framerate 30 -i '%06d.png' -crf 0 $wd/gifs/$loop.mp4
  popd &> /dev/null
  echo rendered gifs/$loop.gif
}

if [[ $1 == "all" ]]; then
  for loop in *.moon; do
    [[ "$loop" = demoloop.moon ]] && continue
    render `basename $loop .moon`
  done
elif [[ -n $1 ]]; then
  render "$@"
else
  echo "usage: '$(basename $0) <loop>' or '$(basename $0) all'"
  exit 1
fi
