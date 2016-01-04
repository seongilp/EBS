#!/bin/bash
EBS="rtmp://ebsandroid.ebs.co.kr:1935/fmradiofamilypc/familypc1m"
PODCAST_XML="podcast.xml"
PROGRAM=$1
RECORD_MINS=$(($2 * 60))
REC_DATE=`date +%Y%m%d`
DATE=`date`
MP3_FILE_NAME=$REC_DATE"_"$PROGRAM.mp3
TEMP_FLV=`mktemp -u`
echo $TEMP_FLV
#rtmpdump -r $EBS -B $RECORD_MINS -o $TEMP_FLV
#avconv -i $TEMP_FLV -ac 2 -ab 128 -vn -y -f mp3 a.mp3
#ffmpeg -i a.mp3 -vn -acodec copy $MP3_FILE_NAME
rm $TEMP_FLV
rm a.mp3
sed -i '$d' $PODCAST_XML
echo "" >> $PODCAST_XML
echo "<item><title>"$MP3_FILE_NAME"</title>" >> $PODCAST_XML
echo "<link>http://zihado.com/ebs/"$MP3_FILE_NAME"</link>" >> $PODCAST_XML
echo "<description>"$MP3_FILE_NAME"</description>" >> $PODCAST_XML
echo "<enclosure url=\"http://zihado.com/ebs/"$MP3_FILE_NAME.mp3\"" length=\"8846264\" type=\"audio/mpeg\" />" >> $PODCAST_XML
echo "<guid isPermaLink=\"true\">http://zihado.com/ebs/"$MP3_FILE_NAME.mp3"</guid>" >> $PODCAST_XML
echo "<pubDate>"$DATE"</pubDate></item>" >> $PODCAST_XML
echo "" >> $PODCAST_XML
echo "</channel></rss>" >> $PODCAST_XML
