#!/bin/bash

DATE=`date +%Y%m%d`
EBSURL="mms://211.218.209.124/L-FM_300k"

FNAME="$1_$DATE"
RECTIME=$2
ASXFNAME="$FPATH/$FNAME.asx"
WAVFNAME="$FPATH/$FNAME.wav"
MP3FNAME="$FPATH/$FNAME.mp3"
MIMMS="/usr/bin/mimms"
MPLAYER="/usr/bin/mplayer"
LAME="/usr/bin/lame"

$MIMMS -q -t $RECTIME $EBSURL $ASXFNAME
$MPLAYER -quiet -vo null -ao pcm:file=$WAVFNAME $ASXFNAME
$LAME --quiet -h $WAVFNAME $MP3FNAME
