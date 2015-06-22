#!/bin/bash

#  RestoreAll SMS R.sh
#
#  Created by LooneySJ

cd ~/Documents/RestoreAll
if [ -f SMS-E.tar.gz.zip ]
then
echo "Decrypting..."
unzip SMS-E.tar.gz.zip
read -p "Messages in your phone will be overwritten. If you have to back it up, back it up right now. (Press enter to continus)"
tar -zxf SMS-E.tar.gz
expect -c"
spawn scp -P 22 -o StrictHostKeyChecking=no -o ConnectTimeout=10 -r SMS root@$SSHIP:/var/mobile/Library/
expect \"root@$SSHIP's password:\"
stty -echo
send \"$SSHROOT\r\"
stty echo
set timeout 7200
expect \"dummy expect\"
"
exit

else

read -p "Messages in your phone will be overwritten. If you have to back it up, back it up right now. (Press enter to continus)"
tar -zxf SMS-E.tar.gz
expect -c"
spawn scp -P 22 -o StrictHostKeyChecking=no -o ConnectTimeout=10 -r SMS root@$SSHIP:/var/mobile/Library/
expect \"root@$SSHIP's password:\"
stty -echo
send \"$SSHROOT\r\"
stty echo
set timeout 7200
expect \"dummy expect\"
"
exit
fi
;;