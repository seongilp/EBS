#!/bin/bash
RADIO_ADDR="http://new_iradio.ebs.co.kr/iradio/iradiolive_m4a/playlist.m3u8"
PROGRAM=$1
RECORD_MINS=$(($2 * 60))
REC_DATE=`date +%Y%m%d`
MP3_FILE_NAME=$REC_DATE"_"$PROGRAM.mp3
rtmp
ffmpeg -i $RADIO_ADDR -t $RECORD_MINS $MP3_FILE_NAME
cp $MP3_FILE_NAME /share/music/EBS/
