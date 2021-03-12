#!/bin/sh

TOKEN=1601278663:AAG-lcnCx4VmNCm8BQSlDjx0qgpR3aEQh-A
CHATID=1033474701
CMD=$1
HABIT_LOG=~/.habitctl/log

cd /shell-bot
supervisor start server.js &

msg()
{
CMD=$1

curl  --data-urlencode "text=$($CMD)" "https://api.telegram.org/bot$TOKEN/sendMessage?chat_id=$CHATID"
}
lastmod(){
    echo $((( $(date +%s) - $(stat -c %X  "$1"))))

}
check_habitctl()
{
atime=$(lastmod $HABIT_LOG)
if [ $atime -gt 3600 ]
then
 msg "habitctl todo"
 touch $HABIT_LOG

fi
}

while :
do

check_habitctl
sleep 60
done