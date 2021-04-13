#!/bin/sh
SCRIPTS_DIR=~/scripts.d
TOKEN=$1
CHATID=$2
HABIT_LOG=~/.habitctl/log
echo "{\"authToken\":\"$1\", \"owner\":$2}" >config.json

cd /app/shell-bot
pm2 start server.js 


msg()
{
CMD=$1
curl  --data-urlencode "text=$($CMD)" "https://api.telegram.org/bot$TOKEN/sendMessage?chat_id=$CHATID"
}
lastmod(){
    echo $((( $(date +%s) - $(stat -c %X  "$1"))))

}

while sleep 5
do

if [ -d $SCRIPTS_DIR ] 
 then 
    for f in $SCRIPTS_DIR/*.sh
        do
        
        echo  "running $f ..." 
        $f $TOKEN $CHATID
        echo "done"
        done
 fi

done
