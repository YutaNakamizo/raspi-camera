#!/bin/bash

VERSION="0.0.1"


echo "Recorder System $VERSION"


# Set $filename
echo 'Save As [default output_yyyymmdd-HHMMSS.mp4]: '
read filename

if [ -z $filename ]; then
  now=`date +'%Y%m%d-%H%M%S'`
  filename="output_$now.mp4"
elif [ ${filename##*.} != 'mp4' ]; then
  filename="$filename.mp4"
fi

echo '$filename = '$filename



# Set $dir
echo 'Save at [default $HOME/video/]: '
read dir

if [ -z $dir ]; then
  dir="$HOME/video/"
elif [ ${dir##*/} != '' ]; then
  dir=$dir'/'
fi

echo '$dir = '$dir



# Record
if [ -z $(which ffmpeg) ]; then
  echo 'ffmpeg is NOT installed.'
  exit 0
fi

echo 'Starting... (Press "q" to stop.)'

ffmpeg -f alsa -ac 1 -thread_queue_size 8192 -i hw:1,0 \
  -f v4l2 -thread_queue_size 8192 -s 640x480 -i /dev/video0 \
  -c:v h264_omx -b:v 768k \
  -c:a aac \
  $dir$filename

echo "Video was saved as $dir$filename"


exit 0

