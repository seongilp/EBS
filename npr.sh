#!/bin/bash

# Script Setup
server=http://someserver.com/npr/me
nprurl=http://www.npr.org/programs/morning-edition/

# Feed Setup
feedTitle="NPR Morning Edition"
feedDescription="NPR Morning Edition Podcast"

# Change to the script's directory
cd "${0%/*}"

# Check if MP3s' Directory Exists, create if does not
if [ ! -d mp3s ]; then
    mkdir mp3s
fi

# Grab and Parce the NPR Page
wget $nprurl -O today
grep "\<input type=\"hidden\" id=\"title" today | sed -e 's/^.*value=\"//g' -e 's/\".*//g' | tail -n +2 > titles
grep dl=1 today | sed -e 's/^.*href=\"//g' -e 's/?dl=1.*$//g' > links
sed -e 's/^.*\///g' links > urls
paste titles links urls > program
rm today titles links urls

# Create the Feed and Grab the MP3s.
# Count is necessary because I want to keep the order of the stories as on NPR.
# To do so the stories are offset in the date tag by 10 min.
count=10
while read data
do
    title=`echo "$data" | cut -f1`
    download=`echo "$data" | cut -f2`
    url=`echo "$data" | cut -f3`
    wget -P mp3s/ $download
    date=`date -R --date="$count minutes ago"`
    let count=count+10
    echo "<item><title>$title</title><enclosure url=\"$server/mp3s/$url\" type=\"audio/mpeg\"/><pubDate>$date</pubDate></item>" >> feed
done < program
rm program

# Delete Old Programs, Keep only the 150 newest once
head -n -150 feed | sed -e 's/^.*mp3s\///g' -e 's/\" type=\"audio\/mpeg\".*//g' > delete
while read file
do
    rm mp3s/$file
done < delete
rm delete

tail -150 feed > temp
cat temp > feed
rm temp

# The Head and Tail Section of the RSS Feed
read -r -d '' HEAD << EOM
<?xml version="1.0" encoding="UTF-8"?>
<rss xmlns:itunes="http://www.itunes.com/dtds/podcast-1.0.dtd" version="2.0">
    <channel>
        <title>$feedTitle</title>
        <description>$feedDescription</description>
        <link>$nprurl</link>
        <language>en-us</language>
        <itunes:image href="$server/logo.jpg"/>
EOM

read -r -d '' TAIL << EOM
    </channel>
</rss>
EOM

# Make the Feed
echo $HEAD > index.html
cat feed >> index.html
echo $TAIL >> index.html
