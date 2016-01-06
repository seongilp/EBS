#!/bin/bash
######
###
# telegram-cli bash script r0.1
# change 'to' to your own  Telegram account name
# by =  Mohammad Hafiz bin Ismail  [mypapit@gmail.com]
# url=  https://blog.mypapit.net/
###
######

## Replace 'to' with your account name

#to=Replace_this_with_your-Telegram_account_name
to=Seongil_Park

##

function show_usage {

        echo "Usage $0 [message]"
        exit
}




if [ $# -lt 1 ]
then
  show_usage
fi

(echo "contact_list";sleep 10;echo "send_audio $to $1"; echo "safe_quit") | /home/zihado/workspace/telegram/tg/bin/telegram-cli -k /home/zihado/workspace/telegram/tg/server.pub
