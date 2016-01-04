#!/bin/bash
#EBS="http://new_iradio.ebs.co.kr/iradio/iradiolive_m4a/playlist.m3u8"
EBS="rtmp://ebsandroid.ebs.co.kr:1935/fmradiofamilypc/familypc1m"
PROGRAM=$1
RECORD_MINS=$(($2 * 60))
REC_DATE=`date +%Y%m%d`
MP3_FILE_NAME=$REC_DATE"_"$PROGRAM.mp3
TEMP_FLV=`mktemp -u`
echo $TEMP_FLV
rtmpdump -r $EBS -B $RECORD_MINS -o $TEMP_FLV
avconv -i $TEMP_FLV -ac 2 -ab 128 -vn -y -f mp3 a.mp3
ffmpeg -i a.mp3 -vn -acodec copy $MP3_FILE_NAME
rm $TEMP_FLV
rm a.mp3
cp $MP3_FILE_NAME /share/music/EBS/
