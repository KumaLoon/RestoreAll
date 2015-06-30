#!/bin/bash

#  RestoreAll.sh
#  iPhone requires APT 0.7 Strict, OpenSSH and OS X/Linux requires zip and unzip to run this.
#
#  Created by LooneySJ

clear
echo "PLEASE BACK UP YOUR DEVICE"
read -p "By pressing a key, you are agreeing to the terms of the software license agreement and you acknowlege all the information that was provided in license file(You can find the license file in the zip file.)"

clear
echo "Welcome to RestoreAll - Beta 6"

# Creating a folder named RestoreAll
mkdir -p ~/Documents/RestoreAll
echo "If you don't a folder named RestoreAll, this will make that folder for you."

# Getting essential information to run. None of this will be stored.
read -p "Please put your iPhone/iPad/iPod's IP address: " SSHIP
stty -echo
read -p "And your root password for your device (will not be showed when you type): " SSHROOT
stty echo


clear
echo "RestoreAll script by LooneySJ"
echo "Support is available in the Twitter! @LooneySJ"
echo "This should work on iOS 2 to 8.3 right now (tested in iOS 6.1.6, 7.1.2 and 8.1.2.)"
echo ""

Menu () {

echo "1. Back up the device"
echo "2. Restore the device"
echo ""
echo "Q. Quit"

read CHOICE

case "$CHOICE" in

1)
HelloMenu () {

clear
echo "1A. Backup Photos"
echo "1B. Backup Music and Videos"
echo "1C. Backup Cydia packages"
echo "1D. Backup Library"
echo "1E. Backup SMS"
echo "1F. Backup All"
echo ""
echo "Q. Quit"

read BCHOICE

case "$BCHOICE" in

1A)
echo "Backing up Photos..."
cd ~/Documents/RestoreAll
mkdir PhotosBackUp
echo "You should see a folder name PhotosBackUp"
sleep 1s
expect -c"
spawn scp -P 22 -o StrictHostKeyChecking=no -o ConnectTimeout=10 -r root@$SSHIP:/var/mobile/Media/DCIM PhotosBackUp
expect \"root@$SSHIP's password:\"
stty -echo
send \"$SSHROOT\r\"
stty echo
set timeout 7200
expect eof
sleep 1
exit
"

expect -c"
spawn scp -P 22 -o StrictHostKeyChecking=no -o ConnectTimeout=10 -r root@$SSHIP:/var/mobile/Media/PhotoData PhotosBackUp
expect \"root@$SSHIP's password:\"
stty -echo
send \"$SSHROOT\r\"
stty echo
set timeout 7200
expect eof
sleep 1
"
;;

1B)
echo "Backing up musics and videos"
cd ~/Documents/RestoreAll
mkdir MVideosBackUp
echo "You should see a folder named MVideosBackUp"
sleep 1s
expect -c"
spawn scp -P 22 -oStrictHostKeyChecking=no -oConnectTimeout=10 -r root@$SSHIP:/var/mobile/Media/iTunes_Control/Music MVideosBackUp
expect \"root@$SSHIP's password:\"
stty -echo
send \"$SSHROOT\r\"
stty echo
set timeout 7200
expect eof
sleep 1
exit
"
;;

1C)
# Only tweaks will be backed up. Cydia will be killed
echo "Backing up Cydia packages"
cd ~/Documents
expect -c"
spawn ssh root@$SSHIP -oStrictHostKeyChecking=no -oConnectTimeout=10
expect \"root@$SSHIP's password:\"
stty -echo
send \"$SSHROOT\r\"
stty echo
expect "#"
send \"killall MobileCydia\r\"
expect "#"
send \"cd /var/mobile\r\"
expect "#"
send \"dpkg --get-selections> cydia-tweak.txt\r\"
expect "#"
send \"exit\r\"
expect \"dummy expect\"
"

expect -c"
spawn scp -P 22 -oStrictHostKeyChecking=no -oConnectTimeout=10 root@$SSHIP:/var/mobile/cydia-tweak.txt RestoreAll
expect \"root@$SSHIP's password:\"
stty -echo
send \"$SSHROOT\r\"
stty echo
expect \"dummy expect\"
"

expect -c"
spawn scp -P 22 -oStrictHostKeyChecking=no -oConnectTimeout=10 -r root@$SSHIP:/etc/apt/sources.list.d RestoreAll
expect \"root@$SSHIP's password:\"
stty -echo
send \"$SSHROOT\r\"
stty echo
expect \"dummy expect\"
"
;;

1D)
echo "Backing up Library"
echo "Just to give you a fair warning, this will take at least 2 minutes!!"
sleep 2s
cd ~/Documents
expect -c"
spawn ssh root@$SSHIP -oStrictHostKeyChecking=no -oConnectTimeout=10
expect \"root@$SSHIP's password:\"
stty -echo
send \"$SSHROOT\r\"
stty echo
expect "#"
send \"cd /var/mobile/Library\r\"
expect "#"
send \"mv Assets /var/mobile\r\"
expect "#"
send \"sleep 2s\r\"
expect "#"
send \"mv Caches /var/mobile\r\"
expect "#"
send \"sleep 2s\r\"
expect "#"
send \"exit\r\"
expect \"dummy expect\"
"

expect -c"
spawn scp -P 22 -oStrictHostKeyChecking=no -oConnectTimeout=10 -r root@$SSHIP:/var/mobile/Library Restoreall
expect \"root@$SSHIP's password:\"
stty -echo
send \"$SSHROOT\r\"
stty echo
set timeout 3600
expect \"dummy expect\"
"

expect -c"
spawn ssh root@$SSHIP -o StrictHostKeyChecking=no -o ConnectTimeout=10
expect \"root@$SSHIP's password:\"
stty -echo
send \"$SSHROOT\r\"
stty echo
expect "#"
send \"cd /var/mobile\r\"
expect "#"
send \"mv Assets /var/mobile/Library\r\"
expect "#"
send \"sleep 2s\r\"
expect "#"
send \"mv Caches /var/mobile/Library\r\"
expect "#"
send \"sleep 2s\r\"
expect "#"
send \"exit\r\"
expect \"dummy expect\"
"
;;

1E)
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
echo "Removing the decrypted version"
rm -rf SMS-E.tar.gz
echo "Done"
exit
else
echo "Compressing messages (F is tar.gz)"
tar -zcvf SMS.tar.gz SMS
echo "Done"
exit
fi
;;

1F)
echo "Backing up Photos..."
cd ~/Documents/RestoreAll
mkdir PhotosBackUp
echo "You should see a folder name PhotosBackUp"
sleep 1s
expect -c"
spawn scp -P 22 -o StrictHostKeyChecking=no -o ConnectTimeout=10 -r root@$SSHIP:/var/mobile/Media/DCIM PhotosBackUp
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

echo "Backing up musics and videos"
cd ~/Documents/RestoreAll
mkdir MVideosBackUp
echo "You should see a folder name MVideosBackUp"
sleep 1s
expect -c"
spawn scp -P 22 -o StrictHostKeyChecking=no -o ConnectTimeout=10 -r root@$SSHIP:/var/mobile/Media/iTunes_Control/Music MVideosBackUp
expect \"root@$SSHIP's password:\"
stty -echo
send \"$SSHROOT\r\"
stty echo
set timeout 7200
expect eof
sleep 1
exit
"

# Only tweaks will be backed up. Cydia will be killed
echo "Backing up Cydia packages"
cd ~/Documents
expect -c"
spawn ssh root@$SSHIP -oStrictHostKeyChecking=no -oConnectTimeout=10
expect \"root@$SSHIP's password:\"
stty -echo
send \"$SSHROOT\r\"
stty echo
expect "#"
send \"killall MobileCydia\r\"
expect "#"
send \"cd /var/mobile\r\"
expect "#"
send \"dpkg --get-selections> cydia-tweak.txt\r\"
expect "#"
send \"exit\r\"
expect \"dummy expect\"
"

expect -c"
spawn scp -P 22 -oStrictHostKeyChecking=no -oConnectTimeout=10 root@$SSHIP:/var/mobile/cydia-tweak.txt RestoreAll
expect \"root@$SSHIP's password:\"
stty -echo
send \"$SSHROOT\r\"
stty echo
expect \"dummy expect\"
"

expect -c"
spawn scp -P 22 -oStrictHostKeyChecking=no -oConnectTimeout=10 -r root@$SSHIP:/etc/apt/sources.list.d RestoreAll
expect \"root@$SSHIP's password:\"
stty -echo
send \"$SSHROOT\r\"
stty echo
expect \"dummy expect\"
"
clear

echo "Backing up Library"
echo "Just to give you a fair warning, this will take at least 2 minutes!!"
sleep 2s
cd ~/Documents
expect -c"
spawn ssh root@$SSHIP -oStrictHostKeyChecking=no -oConnectTimeout=10
expect \"root@$SSHIP's password:\"
stty -echo
send \"$SSHROOT\r\"
stty echo
expect "#"
send \"cd /var/mobile/Library\r\"
expect "#"
send \"mv Assets /var/mobile\r\"
expect "#"
send \"sleep 2s\r\"
expect "#"
send \"mv Caches /var/mobile\r\"
expect "#"
send \"sleep 2s\r\"
expect "#"
send \"exit\r\"
expect \"dummy expect\"
"

expect -c"
spawn scp -P 22 -oStrictHostKeyChecking=no -oConnectTimeout=10 -r root@$SSHIP:/var/mobile/Library Restoreall
expect \"root@$SSHIP's password:\"
stty -echo
send \"$SSHROOT\r\"
stty echo
set timeout 3600
expect \"dummy expect\"
"

expect -c"
spawn ssh root@$SSHIP -o StrictHostKeyChecking=no -o ConnectTimeout=10
expect \"root@$SSHIP's password:\"
stty -echo
send \"$SSHROOT\r\"
stty echo
expect "#"
send \"cd /var/mobile\r\"
expect "#"
send \"mv Assets /var/mobile/Library\r\"
expect "#"
send \"sleep 2s\r\"
expect "#"
send \"mv Caches /var/mobile/Library\r\"
expect "#"
send \"sleep 2s\r\"
expect "#"
send \"exit\r\"
expect \"dummy expect\"
"

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
echo "Removing the decrypted version"
rm -rf SMS-E.tar.gz
echo "Done"
exit
else
echo "Compressing messages (F is tar.gz)"
tar -zcvf SMS.tar.gz SMS
echo "Done"
exit
fi
;;

esac
}
HelloMenu
;;

# Show last menu
2)
clear
Restore_Menu () {

echo "Restore Library funcion is not available for this version"

echo "2A. Restore Photos"
echo "2B. Restore Cydia packages"
echo "2C is not available which is Library."
echo "2D  Restore SMS"
echo "2E. Restore All"
echo ""
echo "Q. Quit"

read RCHOICE

case "$RCHOICE" in

2A)
echo "Moving the existing folders to avoid conflicts (/var/mobile/RestoreAll/DCIM)"
expect -c"
spawn ssh root@$SSHIP -oStrictHostKeyChecking=no -oConnectTimeout=10
expect \"root@$SSHIP's password:\"
stty -echo
send \"$SSHROOT\r\"
stty echo
expect "#"
send \"cd /var/mobile/\r\"
expect "#"
send \"mkdir RestoreAll\r\"
expect "#"
send \"cd /var/mobile/Media/\r\"
expect "#"
send \"mv DCIM /var/mobile/RestoreAll\r\"
expect "#"
send \"mv PhotoData /var/mobile/RestoreAll\r\"
expect "#"
send \"exit\r\"
expect \"dummy expect\"
"

echo "Restoring photos and videos"
cd ~/Documents/RestoreAll/PhotosBackUp
expect -c"
spawn scp -P 22 -o StrictHostKeyChecking=no -o ConnectTimeout=10 -r DCIM root@$SSHIP:/var/mobile/Media/
expect \"root@$SSHIP's password:\"
stty -echo
send \"$SSHROOT\r\"
stty echo
set timeout 7200
expect eof
"

expect -c"
spawn scp -P 22 -o StrictHostKeyChecking=no -o ConnectTimeout=10 -r PhotoData root@$SSHIP:/var/mobile/Media/
expect \"root@$SSHIP's password:\"
stty -echo
send \"$SSHROOT\r\"
stty echo
set timeout 7200
expect eof
"
;;

2B)
echo "Restoring Cydia packages"
cd ~/Documents/RestoreAll
expect -c"
spawn scp -P 22 -o StrictHostKeyChecking=no -o ConnectTimeout=10 cydia-tweak.txt root@$SSHIP:/var/mobile
expect \"root@$SSHIP's password:\"
stty -echo
send \"$SSHROOT\r\"
stty echo
expect \"dummy expect\"
"

expect -c"
spawn scp -P 22 -o StrictHostKeyChecking=no -o ConnectTimeout=10 -r sources.list.d root@$SSHIP:/etc/apt/
expect \"root@$SSHIP's password:\"
stty -echo
send \"$SSHROOT\r\"
stty echo
expect \"dummy expect\"
"

# Again, killing Cydia
expect -c"
spawn ssh root@$SSHIP -o StrictHostKeyChecking=no -o ConnectTimeout=10
expect \"root@$SSHIP's password:\"
stty -echo
send \"$SSHROOT\r\"
stty echo
expect "#"
send \"cd /var/mobile\r\"
expect "#"
send \"killall MobileCydia\r\"
expect "#"
send \"apt-get update\r\"
expect "#"
send \"dpkg --set-selections <cydia-tweak.txt\r\"
expect "#"
send \"apt-get dselect-upgrade\r\"
expect "#"
send \"Y\r\"
expect "#"
send \"Y\r\"
expect eof
send \"exit\r\"
expect \"dummy expect\"
"
echo ""
echo "Please reboot your device!"
;;

2C)
echo "Told you, restoring Library funcion not available"
;;

2D)
cd ~/Documents/RestoreAll
if [ -f SMS-E.tar.gz.zip ]
then
echo "Decrypting..."
unzip SMS-E.tar.gz.zip
read -p "Messages in your phone will be overwritten. If you have to back it up, back it up right now. (Press enter to continue)"
tar -zxf SMS-E.tar.gz
expect -c"
spawn scp -P 22 -o StrictHostKeyChecking=no -o ConnectTimeout=10 -r SMS root@$SSHIP:/var/mobile/Library/
expect \"root@$SSHIP's password:\"
stty -echo
send \"$SSHROOT\r\"
stty echo
set timeout 7200
expect eof
"
echo ""
echo "Please reboot your device!"
exit

else

read -p "Messages in your phone will be overwritten. If you have to back it up, back it up right now. (Press enter to continue)"
tar -zxf SMS-E.tar.gz
expect -c"
spawn scp -P 22 -o StrictHostKeyChecking=no -o ConnectTimeout=10 -r SMS root@$SSHIP:/var/mobile/Library/
expect \"root@$SSHIP's password:\"
stty -echo
send \"$SSHROOT\r\"
stty echo
set timeout 7200
expect eof
"
echo ""
echo "Please reboot your device!"
exit
fi
;;

2E)
echo "Moving the existing folders to avoid conflicts (/var/mobile/RestoreAll/DCIM)"
expect -c"
spawn ssh root@$SSHIP -oStrictHostKeyChecking=no -oConnectTimeout=10
expect \"root@$SSHIP's password:\"
stty -echo
send \"$SSHROOT\r\"
stty echo
expect "#"
send \"cd /var/mobile/\r\"
expect "#"
send \"mkdir RestoreAll\r\"
expect "#"
send \"cd /var/mobile/Media/\r\"
expect "#"
send \"mv DCIM /var/mobile/RestoreAll\r\"
expect "#"
send \"mv PhotoData /var/mobile/RestoreAll\r\"
expect "#"
send \"exit\r\"
expect \"dummy expect\"
"

echo "Restoring photos and videos"
cd ~/Documents/RestoreAll/PhotosBackUp
expect -c"
spawn scp -P 22 -o StrictHostKeyChecking=no -o ConnectTimeout=10 -r DCIM root@$SSHIP:/var/mobile/Media/
expect \"root@$SSHIP's password:\"
stty -echo
send \"$SSHROOT\r\"
stty echo
set timeout 7200
expect eof
"

expect -c"
spawn scp -P 22 -o StrictHostKeyChecking=no -o ConnectTimeout=10 -r PhotoData root@$SSHIP:/var/mobile/Media/
expect \"root@$SSHIP's password:\"
stty -echo
send \"$SSHROOT\r\"
stty echo
set timeout 7200
expect eof
"

sleep 1s

echo "Restoring Cydia packages"
cd ~/Documents/RestoreAll
expect -c"
spawn scp -P 22 -o StrictHostKeyChecking=no -o ConnectTimeout=10 cydia-tweak.txt root@$SSHIP:/var/mobile
expect \"root@$SSHIP's password:\"
stty -echo
send \"$SSHROOT\r\"
stty echo
expect \"dummy expect\"
"

expect -c"
spawn scp -P 22 -o StrictHostKeyChecking=no -o ConnectTimeout=10 -r sources.list.d root@$SSHIP:/etc/apt/
expect \"root@$SSHIP's password:\"
stty -echo
send \"$SSHROOT\r\"
stty echo
expect \"dummy expect\"
"

# Again, killing Cydia
expect -c"
spawn ssh root@$SSHIP -o StrictHostKeyChecking=no -o ConnectTimeout=10
expect \"root@$SSHIP's password:\"
stty -echo
send \"$SSHROOT\r\"
stty echo
expect "#"
send \"cd /var/mobile\r\"
expect "#"
send \"killall MobileCydia\r\"
expect "#"
send \"apt-get update\r\"
expect "#"
send \"dpkg --set-selections <cydia-tweak.txt\r\"
expect "#"
send \"apt-get dselect-upgrade\r\"
expect "#"
send \"Y\r\"
expect "#"
send \"Y\r\"
expect eof
send \"exit\r\"
expect \"dummy expect\"
"

clear

cd ~/Documents/RestoreAll
if [ -f SMS-E.tar.gz.zip ]
then
echo "Decrypting..."
unzip SMS-E.tar.gz.zip
read -p "Messages in your phone will be overwritten. If you have to back it up, back it up right now. (Press enter to continue)"
tar -zxf SMS-E.tar.gz
expect -c"
spawn scp -P 22 -o StrictHostKeyChecking=no -o ConnectTimeout=10 -r SMS root@$SSHIP:/var/mobile/Library/
expect \"root@$SSHIP's password:\"
stty -echo
send \"$SSHROOT\r\"
stty echo
set timeout 7200
expect eof
"
exit

else

read -p "Messages in your phone will be overwritten. If you have to back it up, back it up right now. (Press enter to continue)"
tar -zxf SMS-E.tar.gz
expect -c"
spawn scp -P 22 -o StrictHostKeyChecking=no -o ConnectTimeout=10 -r SMS root@$SSHIP:/var/mobile/Library/
expect \"root@$SSHIP's password:\"
stty -echo
send \"$SSHROOT\r\"
stty echo
set timeout 7200
expect eof
"
exit
fi
echo ""
echo "Please reboot your device"
;;

esac
}
Restore_Menu
;;

[Qq]) clear; exit;;

*)
Menu
;;
esac
}
Menu