#!/bin/bash

#  RestoreAll SMS.sh
#
#  Created by LooneySJ

cd ~/Documents
echo "Exporting Messages"
expect -c"
spawn scp -P 22 -oStrictHostKeyChecking=no -oConnectTimeout=10 -r root@$SSHIP:/var/mobile/Library/SMS RestoreAll
expect \"root@$SSHIP's password:\"
stty -echo
send \"$SSHROOT\r\"
stty echo
set timeout 7200
expect eof
sleep 1
exit
"
clear

cd ~/Documents/RestoreAll
# STILL TESTING, PLANING TO PUT A STOREAGE WARNING HERE.
read -p "SMS can be encrypted, do you want to encrypt your messages? (Y/N): " ECSMS
if [ "$ECSMS" == "Y" ]
then
# I'M SERIOUS ABOUT THIS, REMEMBER YOUR PASSWORD!!!
echo "NOTE: This program will NOT SAVE your encryption password, know your password, or you will have to Brute-force to unzip the messages."
sleep 4s
echo "Compressing messages (F is tar.gz)"
tar -zcvf SMS-E.tar.gz SMS
clear
echo "Encrypting messages. Please type your password for zip."
zip -er SMS-E.tar.gz.zip SMS-E.tar.gz
echo "Done"
exit
else
echo "Compressing messages (F is tar.gz)"
tar -zcvf SMS.tar.gz SMS
echo "Done"
exit
fi
;;