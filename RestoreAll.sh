#!/bin/bash

#  RestoreAll.sh
#  Require APT 0.7 Strict, OpenSSH to run this.
#
#  Created by LooneySJ

clear
echo "PLEASE BACK UP YOUR DEVICE"
read -p "By pressing a key, you are agreeing to the terms of the software license agreement and you acknowlege all the information that was provided (You can find the license file in the zip file.)"

clear
echo "Welcome to RestoreAll - Beta 4"

# Creating a folder named RestoreAll
mkdir -p ~/Documents/RestoreAll
echo "If you don't a folder named RestoreAll, this will make that folder for you."

# Getting essential information to run. None of this will be stored.
read -p "Please put your iPhone/iPad/iPod's IP address: " SSHIP
stty -echo
read -p "And your root password for your device (will not be showed when you type): " SSHROOT
stty echo

clear
echo "RestoreAll Beta script by LooneySJ"
echo "Support is available in the Twitter! @LooneySJ"
echo "This works on iOS 2 to 8.1.2 right now (tested on iOS 6.1.6, 7.1.2 and 8.1.2.)"
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
echo "1E. Backup All"
echo ""
echo "Q. Quit"

read BCHOICE

case "$BCHOICE" in

1A)
echo "Backing up Photos..."
cd ~/Documents/RestoreAll
mkdir PhotosBackUp
echo "You should see a folder name PhotosBackUp"
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
;;

1B)
echo "Backing up musics and videos"
cd ~/Documents/RestoreAll
mkdir MVideosBackUp
echo "You should see a folder named MVideosBackUp"
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
;;

1D)
echo "Backing up Library"
echo "Just to give you a fair warning, this will take at least 2 minutes!!"
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
echo "Backing up Photos..."
cd ~/Documents/RestoreAll
mkdir PhotosBackUp
echo "You should see a folder name PhotosBackUp"
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

echo "Backing up musics and videos"
cd ~/Documents/RestoreAll
mkdir MVideosBackUp
echo "You should see a folder name MVideosBackUp"
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
send \"dpkg --get-selections> cydia-tweak.txt\r\"
expect "#"
send \"exit\r\"
expect \"dummy expect\"
"

expect -c"
spawn scp -P 22 -o StrictHostKeyChecking=no -o ConnectTimeout=10 root@$SSHIP:/var/mobile/cydia-tweak.txt RestoreAll
expect \"root@$SSHIP's password:\"
stty -echo
send \"$SSHROOT\r\"
stty echo
expect \"dummy expect\"
"

echo "Backing up Library"
echo "Just to give you a fair warning, this will take at least 2 minutes!!"
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
echo "2D. Restore All"
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
set timeout 3600
expect eof
send \"sleep 2s\r\"
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
expect \"dummy expect\"
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
set timeout 3600
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
set timeout 3600
expect eof
send \"sleep 2s\r\"
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
expect \"dummy expect\"
"
sleep 1s

echo "Moving the existing folders to avoid conflicts (/var/mobile/RestoreAll/Music)"
expect -c"
spawn ssh root@$SSHIP -oStrictHostKeyChecking=no -oConnectTimeout=10
expect \"root@$SSHIP's password:\"
stty -echo
send \"$SSHROOT\r\"
stty echo
expect "#"
send \"cd /var/mobile/Media/iTunes_Control\r\"
expect "#"
send \"mv Music /var/mobile/RestoreAll\r\"
expect "#"
set timeout 7200
expect eof
send \"sleep 2s\r\"
expect "#"
send \"exit\r\"
expect \"dummy expect\"
"

echo "Restoring musics and videos"
cd ~/Documents/RestoreAll/MVideosBackUp
expect -c"
spawn scp -P 22 -o StrictHostKeyChecking=no -o ConnectTimeout=10 -r Music root@$SSHIP:/var/mobile/Media/iTunes_Control/Music
expect \"root@$SSHIP's password:\"
stty -echo
send \"$SSHROOT\r\"
stty echo
set timeout 7200
expect eof
expect \"dummy expect\"
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
set timeout 7200
expect \"dummy expect\"
"

# Again, killing Cydia
expect -c"
timeout -1
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
set timeout 3600
expect "#"
send \"exit\r\"
expect \"dummy expect\"
"
echo ""
echo "Please reboot your device!"
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