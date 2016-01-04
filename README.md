1. rtsp://ebsandroid.ebs.co.kr/fmradiotablet500k/tablet500k
2. http://new_iradio.ebs.co.kr/iradio/iradiolive_m4a/playlist.m3u8
3. http://blog.alghost.co.kr/ebs%EB%93%A3%EA%B8%B0/

wget -q -O- "http://www.rss-specifications.com/rss-podcast.xml" | grep -o '<enclosure url="[^"]*' | grep -o '[^"]*$' | xargs wget -c
http://www.rss-specifications.com/rss-podcast.xml

필요 패키지
```
$ sudo apt-get install rtmpdump libav-tools
$ sudo apt-get install ffmpeg
```

```
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
```


ebs2.sh

```
#!/bin/bash
RADIO_ADDR="http://new_iradio.ebs.co.kr/iradio/iradiolive_m4a/playlist.m3u8"
PROGRAM=$1
RECORD_MINS=$(($2 * 60))
REC_DATE=`date +%Y%m%d`
MP3_FILE_NAME=$REC_DATE"_"$PROGRAM.mp3
ffmpeg -i $RADIO_ADDR -t $RECORD_MINS $MP3_FILE_NAME
cp $MP3_FILE_NAME /share/music/EBS/
```

crontab -l

```
50 5 * * 1-6 $HOME/workspace/ebs/ebs.sh PocketEnglish 10
0 6 * * 1-6 $HOME/workspace/ebs/ebs.sh ToeicKing 20
20 6 * * 1-6 $HOME/workspace/ebs/ebs.sh EasyWriting 20
40 6 * * 1-6 $HOME/workspace/ebs/ebs.sh EarEnglish 20
0 7 * * 1-6 $HOME/workspace/ebs/ebs.sh MouseEnglish 20
20 7 * * 1-6 $HOME/workspace/ebs/ebs.sh EasyEnglish 20
40 7 * * 1-6 $HOME/workspace/ebs/ebs.sh PowerEnglish 20
20 23 * * 1-6 $HOME/workspace/ebs/ebs.sh BizEnglish 20
```
