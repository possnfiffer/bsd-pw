#!/bin/sh
#echo Setting sysctl to attached microphone
#sysctl hw.snd.default_unit=0
mixer
read pause
set -x
sleep 1

# -loglevel error \
# -i :0.0+1650,50 \
#  -i /dev/dsp1 \
ffmpeg \
  -thread_queue_size 2048 \
  -f oss \
  -i /dev/dsp0 \
  -f x11grab -show_region 1 \
  -s hd720 \
  -i :0.0 \
  -c:v libx264 \
  -framerate 29.97 \
  -preset fast \
  -pix_fmt yuv420p \
  -b:a 160K \
  -metadata author="Roller Angel, bsd.pw, @possnfiffer" \
  -metadata title="${@}" \
  -movflags +faststart \
  -f mp4 \
output.mp4
