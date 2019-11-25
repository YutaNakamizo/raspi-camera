#!/bin/bash
VERSION=0.0.1

echo "Streamer System $VERSION"


# Check conflict
NUM=`ps aux | grep ffmpeg | grep -v grep | wc -l`
if [ $NUM -gt 0 ]; then
  echo 'Streamer is Already running.'
  exit
fi

# Start stream
sudo ffmpeg \
  -f alsa -ac 1 -thread_queue_size 8192 \
  -i hw:1,0 -f v4l2 -thread_queue_size 8192 \
  -input_format yuyv422 -video_size 432x240 \
  -framerate 30 -i /dev/video0 -c:v h264_omx \
  -c:a aac -b:a 128k -ar 44100 -af "volume=30dB" \
  -f flv rtmp://localhost/live/stream > /dev/null 2>&1 </dev/null &
