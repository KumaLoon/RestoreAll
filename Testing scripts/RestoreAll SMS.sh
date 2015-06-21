#!/bin/bash

#  RestoreAll SMS.sh
#
#  Created by LooneySJ
#  Only Backup is available right now. Restore will be added later.

cd ~/Documents/RestoreAll
echo "Exporting Messages"
mkdir SMS
echo "You should see a folder named SMS"
expect -c"
spawn scp -P 22 -oStrictHostKeyChecking=no -oConnectTimeout=10 -r root@$SSHIP:/var/mobile/Library/SMS SMS
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

# STILL TESTING, PLANING TO PUT A STOREAGE WARNING HERE.
read -p "SMS can be encrypted, do you want to encrypt your messages? (Y/N): " ECSMS
if [ "$ECSMS" == "Y" ]
then
# I'M SERIOUS ABOUT THIS, REMEMBER YOUR PASSWORD!!!
echo "NOTE: This program will NOT SAVE your encryption password, know your password, or you will have to Brute-force to unzip the messages."
sleep 4s
echo "Zipping messages"
zip -r SMS-E SMS
echo "Encrypting messages. Please type your password for zip."
zip -er SMS-E.zip ~/Documents/RestoreAll
echo "Done"
exit
else
echo "Done"
exit
fi
;;
