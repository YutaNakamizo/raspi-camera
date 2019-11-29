#!/bin/bash
VERSION="0.1.0"

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
echo 'Save at [default /mnt/ssd-01/video/]: '
read dir

if [ -z $dir ]; then
  dir="/mnt/ssd-01/video/"
elif [ ${dir##*/} != '' ]; then
  dir=$dir'/'
fi

echo '$dir = '$dir



# Set $mic
echo 'Select Mic [default 0]'
arecord -l
read $mic

if [ -z $mic ]; then
  mic="0"
fi


# Set $camera
echo 'Select Camera [default /dev/video0]'
v4l2-ctl --list-devices
read $camera

if [ -z $camera ]; then
  camera='/dev/video0'
fi


# Record
if [ -z $(which ffmpeg) ]; then
  echo 'ffmpeg is NOT installed.'
  exit 0
fi

echo 'Starting... (Press "q" to stop.)'

ffmpeg -f alsa -ac 1 -thread_queue_size 8192 -i hw:$mic,0 \
  -f v4l2 -thread_queue_size 8192 -s 720x480 -i $camera \
  -c:v h264_omx -b:v 5000k \
  -c:a aac \
  $dir$filename

echo "Video was saved as $dir$filename"


exit 0

