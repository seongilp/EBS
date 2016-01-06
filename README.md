# EBS 자동녹음

## 사전 지식
1. 리눅스에 대한 기본 명령어
2. 쉘스크립트

## 필요 패키지 설치

```
$ sudo apt-get install ffmpeg rtmpdump libav-tools
```


## 쉘스크립트
```
#!/bin/bash
EBS="rtmp://ebsandroid.ebs.co.kr:1935/fmradiofamilypc/familypc1m"
PODCAST_XML=$HOME"/workspace/ebs/podcast.xml"
DOMAIN="http://podcast.com"
PROGRAM=$1
RECORD_MINS=$(($2 * 60))
REC_DATE=`date +%Y%m%d`
DATE=`date`
MP3_FILE_NAME=$REC_DATE"_"$PROGRAM.mp3
MP3_TEMP=$REC_DATE"_"$PROGRAM_TEMP.mp3
TEMP_FLV=`mktemp -u`
echo $TEMP_FLV
rtmpdump -r $EBS -B $RECORD_MINS -o $TEMP_FLV
avconv -i $TEMP_FLV -ac 2 -ab 128 -vn -y -f mp3 $MP3_TEMP
ffmpeg -i $MP3_TEMP -vn -acodec copy $MP3_FILE_NAME
rm $TEMP_FLV
rm $MP3_TEMP
cp $MP3_FILE_NAME /share/music/EBS/

sed -i '$d' $PODCAST_XML
echo "" >> $PODCAST_XML
echo "<item><title>"$MP3_FILE_NAME"</title>" >> $PODCAST_XML
echo "<link>"$DOMAIN"$MP3_FILE_NAME"</link>" >> $PODCAST_XML
echo "<description>"$MP3_FILE_NAME"</description>" >> $PODCAST_XML
echo "<enclosure url=\"$DOMAIN"/"$MP3_FILE_NAME.mp3\"" length=\"8846264\" type=\"audio/mpeg\" />" >> $PODCAST_XML
echo "<guid isPermaLink=\"true\">$DOMAIN"/"$MP3_FILE_NAME.mp3"</guid>" >> $PODCAST_XML
echo "<pubDate>"$DATE"</pubDate></item>" >> $PODCAST_XML
echo "" >> $PODCAST_XML
echo "</channel></rss>" >> $PODCAST_XML
```

## PODCAST.XML
```
<?xml version="1.0" encoding="utf-8" ?>
<rss version="2.0">
<channel>
    <title>EBS Podcast</title>
    <link>http://YOUR-DOMAIN/podcast.xml</link>
    <description>EBS Podcast</description>
    <lastBuildDate>Mon 4 Jan 09:09:09 KST 2016</lastBuildDate>
    <docs>http://blogs.law.harvard.edu/tech/rss</docs>

```


## crontab을 이용한 자동화

```
$ crontab -l
50 5 * * 1-6 $HOME/workspace/ebs/ebs.sh PocketEnglish 10
0 6 * * 1-6 $HOME/workspace/ebs/ebs.sh ToeicKing 20
20 6 * * 1-6 $HOME/workspace/ebs/ebs.sh EasyWriting 20
40 6 * * 1-6 $HOME/workspace/ebs/ebs.sh EarEnglish 20
0 7 * * 1-6 $HOME/workspace/ebs/ebs.sh MouseEnglish 20
20 7 * * 1-6 $HOME/workspace/ebs/ebs.sh EasyEnglish 20
40 7 * * 1-6 $HOME/workspace/ebs/ebs.sh PowerEnglish 20
20 23 * * 1-6 $HOME/workspace/ebs/ebs.sh BizEnglish 20
```

## 참고 링크 
1. rtsp://ebsandroid.ebs.co.kr/fmradiotablet500k/tablet500k
2. http://new_iradio.ebs.co.kr/iradio/iradiolive_m4a/playlist.m3u8
3. http://blog.alghost.co.kr/ebs%EB%93%A3%EA%B8%B0/
4. wget -q -O- "http://www.rss-specifications.com/rss-podcast.xml" | grep -o '<enclosure url="[^"]*' | grep -o '[^"]*$' | xargs wget -c
http://www.rss-specifications.com/rss-podcast.xml
