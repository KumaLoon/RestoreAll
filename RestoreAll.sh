#!/bin/bash

#  RestoreAll.sh
#  iPhone requires APT 0.7 Strict, OpenSSH. OS X requires zip and unzip to run this.
#
#  Created by LooneySJ

SCRAPP = /Applications/Utilities/Terminal.app/

clear
echo "PLEASE BACK UP YOUR DEVICE"
read -p "By pressing a key, you are agreeing to the terms of the software license agreement and you acknowlege all the information about this program and resources that this program uses."

clear

# Creating a folder named RestoreAll
if [ -d ~/Documents/RestoreAll ]; then
        clear
    else
        cd Documents
        mkdir RestoreAll
        echo "Created folder named RestoreAll in Documents"
        sleep 2s
        clear
fi

echo "Welcome to RestoreAll - Beta 11"
echo ""

# Getting essential information to run. None of this will be stored.
read -p "Please put your iPhone/iPad/iPod's IP address (If you want to connect by USB, type localhost): " SSHIP
stty -echo
read -p "And your root password for your device (will not be showed when you type): " SSHROOT
stty echo
clear

if [ "$SSHIP" == "localhost" ]; then
    PORT=2222
    echo "Removing localhost from the known_hosts"
    if [ -f known_hosts.old ]; then
        mv known_hosts.old known_hosts.older
        ssh-keygen -R $SSHIP
        echo "REMOVED"
    else
        ssh-keygen -R $SSHIP
        echo "REMOVED"
    fi
    echo "Plug in your device"
    LOCAL=$( cd $(dirname $0) ; pwd -P )
    chmod +x $LOCAL/USB.command
    open $LOCAL/USB.command
else
    PORT=22
    cd ~/.ssh
    echo "Also note that your iPhone/iPad/iPod's IP address is going to be removed from ~/.ssh/known_hosts. see the ~/.ssh/known_hosts.old for the originals."
    sleep 4s
        if [ -f known_hosts.old ]; then
            mv known_hosts.old known_hosts.older
            ssh-keygen -R $SSHIP
            echo "REMOVED"
        else
            ssh-keygen -R $SSHIP
            echo "REMOVED"
        fi
fi

echo "Retriving iOS verison... (type your password (just for this beta))"
iOSVER=$(ssh root@$SSHIP -p $PORT -oStrictHostKeyChecking=no -oConnectTimeout=20 sw_vers -productVersion)
echo $?
echo "Your iOS versions is iOS" $iOSVER

clear
# Error checker for Library (Working on it.)
if [ -d ~/Documents/RAlock ]; then
    read -P "You are seeing this message because you have turned off the during the Library Backing up process which will cause may cause the system to malfucion. Do you want RestoreAll to try to fix this problem? (Y/N) *If you are not having any problems with your device do not run it, this may break your device" RAfix
    if [ $RAfix = Y ]; then
        echo "Sending the script to the device"
        LOCAL=$( cd $(dirname $0) ; pwd -P )
        expect -c"
        spawn scp -P $PORT -o StrictHostKeyChecking=no -o ConnectTimeout=20 -r $LOCAL/fixitplz.sh root@$SSHIP:/var/mobile/
        expect \"root@$SSHIP's password:\"
        stty -echo
        send \"$SSHROOT\r\"
        stty echo
        set timeout -1
        expect eof
        "

        expect -c"
        spawn ssh root@$SSHIP -p $PORT -o StrictHostKeyChecking=no -o ConnectTimeout=20
        expect \"root@$SSHIP's password:\"
        stty -echo
        send \"$SSHROOT\r\"
        stty echo
        expect "#"
        send \"cd /var/mobile\r\"
        expect "#"
        send \"chmod +x fixitplz.sh\r\"
        expect "#"
        send \"./fixitplz.sh\r\"
        expect "#"
        send \"exit\r\"
        expect \"dummy expect\"
        clear
        "
    else
        echo "OK"
        sleep 1s
        clear
    fi
else
    clear
fi

echo "RestoreAll by LooneySJ"
echo "Report any issues to github.com/LooneySJ"
echo "This should work on iOS 2 to 8.4 right now (tested on iOS 5.0.1, 5.1.1, 6.1.6, 7.1.2, 8.1.2, 8.3 and 8.4)"
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
echo "1D. Backup Library (iOS 9: X)"
echo "1E. Backup All"
echo ""
echo "Q. Quit"

read BCHOICE

case "$BCHOICE" in

1A)
echo "Backing up Photos..."
cd ~/Documents/RestoreAll
if [ -d ~/Documents/RestoreAll/PhotosBackUp ]; then
    clear
else
    cd ~/Documents/RestoreAll/
    mkdir PhotosBackUp
    echo "Created folder named PhotosBackUp in RestoreAll folder"
fi
mkdir RAlock

sleep 1s
expect -c"
spawn scp -P $PORT -o StrictHostKeyChecking=no -o ConnectTimeout=20 -r root@$SSHIP:/var/mobile/Media/DCIM PhotosBackUp
expect \"root@$SSHIP's password:\"
stty -echo
send \"$SSHROOT\r\"
stty echo
set timeout -1
expect eof
sleep 1
"

expect -c"
spawn scp -P $PORT -o StrictHostKeyChecking=no -o ConnectTimeout=20 -r root@$SSHIP:/var/mobile/Media/PhotoData PhotosBackUp
expect \"root@$SSHIP's password:\"
stty -echo
send \"$SSHROOT\r\"
stty echo
set timeout -1
expect eof
sleep 1

rm -rf ~/Documents/RAlock

if [ "$SSHIP" == "localhost" ]; then
    killall itnl
    exit
else
    exit
fi
"
;;

1B)
echo "Backing up musics and videos"
cd ~/Documents/RestoreAll
if [ -d ~/Documents/RestoreAll/MVideosBackUp ]; then
    clear
else
    cd ~/Documents/RestoreAll/
    mkdir MVideosBackUp
    echo "Created folder named MVideosBackUp in RestoreAll folder"
fi
sleep 1s
expect -c"
spawn scp -P $PORT -oStrictHostKeyChecking=no -oConnectTimeout=20 -r root@$SSHIP:/var/mobile/Media/iTunes_Control/Music MVideosBackUp
expect \"root@$SSHIP's password:\"
stty -echo
send \"$SSHROOT\r\"
stty echo
set timeout -1
expect eof
sleep 1
if [ "$SSHIP" == "localhost" ]; then
    killall itnl
    exit
else
    exit
fi
"
;;

1C)
# Only tweaks will be backed up. Cydia will be killed
echo "Backing up Cydia packages"
cd ~/Documents
expect -c"
spawn ssh root@$SSHIP -p $PORT -oStrictHostKeyChecking=no -oConnectTimeout=20
expect \"root@$SSHIP's password:\"
stty -echo
send \"$SSHROOT\r\"
stty echo
expect "#"
send \"killall Cydia\r\"
expect "#"
send \"cd /var/mobile\r\"
expect "#"
send \"dpkg --get-selections> cydia-tweak.txt\r\"
expect "#"
send \"exit\r\"
expect \"dummy expect\"
"

expect -c"
spawn scp -P $PORT -oStrictHostKeyChecking=no -oConnectTimeout=20 root@$SSHIP:/var/mobile/cydia-tweak.txt RestoreAll
expect \"root@$SSHIP's password:\"
stty -echo
send \"$SSHROOT\r\"
stty echo
expect \"dummy expect\"
"

expect -c"
spawn scp -P $PORT -oStrictHostKeyChecking=no -oConnectTimeout=20 -r root@$SSHIP:/etc/apt/sources.list.d RestoreAll
expect \"root@$SSHIP's password:\"
stty -echo
send \"$SSHROOT\r\"
stty echo
expect \"dummy expect\"
"
if [ "$SSHIP" == "localhost" ]; then
    killall itnl
    exit
else
    exit
fi
;;

1D)
# Cydia will be killed
echo "Backing up Library"
sleep 2s
cd ~/Documents
expect -c"
spawn ssh root@$SSHIP -p $PORT -oStrictHostKeyChecking=no -oConnectTimeout=20
expect \"root@$SSHIP's password:\"
stty -echo
send \"$SSHROOT\r\"
stty echo
expect "#"
send \"cd /var/mobile/Library\r\"
expect "#"
send \"mv Assets /var/mobile\r\"
expect "#"
send \"killall Cydia\r\"
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
spawn scp -P $PORT -oStrictHostKeyChecking=no -oConnectTimeout=20 -r root@$SSHIP:/var/mobile/Library Restoreall
expect \"root@$SSHIP's password:\"
stty -echo
send \"$SSHROOT\r\"
stty echo
set timeout -1
expect \"dummy expect\"
"
clear

read -p "SMS can be encrypted, do you want to encrypt your messages? (Y/N): " ECSMS
if [ "$ECSMS" == "Y" ]; then
    echo "This program will NOT SAVE your encryption password, know your password, or you will have to Brute-force to unzip the messages."
    sleep 4s
    cd ~/Documents/RestoreAll
    echo "Compressing messages (F is tar.gz)"
    tar -zcvf SMS-E.tar.gz Library/SMS
    clear
    echo "Encrypting messages. Please type your password for zip."
    zip -er SMS-E.tar.gz.zip SMS-E.tar.gz
    echo "Removing the decrypted version"
    rm -rf SMS-E.tar.gz
    rm -rf Library/SMS
    echo "Done"
else
    echo "Compressing messages (F is tar.gz)"
    tar -zcvf SMS-E.tar.gz Library/SMS
    rm -rf SMS
    echo "Done"
fi

expect -c"
spawn ssh root@$SSHIP -p $PORT -o StrictHostKeyChecking=no -o ConnectTimeout=20
expect \"root@$SSHIP's password:\"
stty -echo
send \"$SSHROOT\r\"
stty echo
expect "#"
send \"cd /var/mobile\r\"
expect "#"
send \"rm -rf Library/Assets\r\"
expect "#"
send \"mv Assets /var/mobile/Library\r\"
expect "#"
send \"sleep 2s\r\"
expect "#"
send \"killall Cydia\r\"
expect "#"
send \"rm -rf Library/Caches\r\"
expect "#"
send \"mv Caches /var/mobile/Library\r\"
expect "#"
send \"sleep 2s\r\"
expect "#"
send \"exit\r\"
expect \"dummy expect\"
"

rm -rf ~/Documents/RAlock

if [ "$SSHIP" == "localhost" ]; then
    killall itnl
    exit
else
    exit
fi
;;

1E)
echo "Backing up Photos..."
cd ~/Documents/RestoreAll
if [ -d ~/Documents/RestoreAll/PhotosBackUp ]; then
    clear
else
    cd ~/Documents/RestoreAll/
    mkdir PhotosBackUp
    echo "Created folder named PhotosBackUp in RestoreAll folder"
fi
mkdir RAlock

sleep 1s
expect -c"
spawn scp -P $PORT -o StrictHostKeyChecking=no -o ConnectTimeout=20 -r root@$SSHIP:/var/mobile/Media/DCIM PhotosBackUp
expect \"root@$SSHIP's password:\"
stty -echo
send \"$SSHROOT\r\"
stty echo
set timeout -1
expect eof
sleep 1
"

expect -c"
spawn scp -P $PORT -o StrictHostKeyChecking=no -o ConnectTimeout=20 -r root@$SSHIP:/var/mobile/Media/PhotoData PhotosBackUp
expect \"root@$SSHIP's password:\"
stty -echo
send \"$SSHROOT\r\"
stty echo
set timeout -1
expect eof
sleep 1
exit
"
clear

echo "Backing up musics and videos"
cd ~/Documents/RestoreAll
if [ -d ~/Documents/RestoreAll/MVideosBackUp ]; then
clear
else
cd ~/Documents/RestoreAll/
mkdir MVideosBackUp
echo "Created folder named MVideosBackUp in RestoreAll folder"
fi
sleep 1s
expect -c"
spawn scp -P $PORT -oStrictHostKeyChecking=no -oConnectTimeout=20 -r root@$SSHIP:/var/mobile/Media/iTunes_Control/Music MVideosBackUp
expect \"root@$SSHIP's password:\"
stty -echo
send \"$SSHROOT\r\"
stty echo
set timeout -1
expect eof
sleep 1
exit
"
clear

# Only tweaks will be backed up. Cydia will be killed
echo "Backing up Cydia packages"
cd ~/Documents
expect -c"
spawn ssh root@$SSHIP -p $PORT -oStrictHostKeyChecking=no -oConnectTimeout=20
expect \"root@$SSHIP's password:\"
stty -echo
send \"$SSHROOT\r\"
stty echo
expect "#"
send \"killall Cydia\r\"
expect "#"
send \"cd /var/mobile\r\"
expect "#"
send \"dpkg --get-selections> cydia-tweak.txt\r\"
expect "#"
send \"exit\r\"
expect \"dummy expect\"
"

expect -c"
spawn scp -P $PORT -oStrictHostKeyChecking=no -oConnectTimeout=20 root@$SSHIP:/var/mobile/cydia-tweak.txt RestoreAll
expect \"root@$SSHIP's password:\"
stty -echo
send \"$SSHROOT\r\"
stty echo
expect \"dummy expect\"
"

expect -c"
spawn scp -P $PORT -oStrictHostKeyChecking=no -oConnectTimeout=20 -r root@$SSHIP:/etc/apt/sources.list.d RestoreAll
expect \"root@$SSHIP's password:\"
stty -echo
send \"$SSHROOT\r\"
stty echo
expect \"dummy expect\"
"
clear

echo "Backing up Library"
sleep 2s
cd ~/Documents
touch RAlock
expect -c"
spawn ssh root@$SSHIP -p $PORT -oStrictHostKeyChecking=no -oConnectTimeout=20
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
spawn scp -P $PORT -oStrictHostKeyChecking=no -oConnectTimeout=20 -r root@$SSHIP:/var/mobile/Library Restoreall
expect \"root@$SSHIP's password:\"
stty -echo
send \"$SSHROOT\r\"
stty echo
set timeout -1
expect \"dummy expect\"
"

expect -c"
spawn ssh root@$SSHIP -p $PORT -o StrictHostKeyChecking=no -o ConnectTimeout=20
expect \"root@$SSHIP's password:\"
stty -echo
send \"$SSHROOT\r\"
stty echo
expect "#"
send \"cd /var/mobile\r\"
expect "#"
send \"rm -rf Library/Assets"
expect "#"
send \"mv Assets /var/mobile/Library\r\"
expect "#"
send \"sleep 2s\r\"
expect "#"
send \"rm -rf Library/Caches"
expect "#"
send \"mv Caches /var/mobile/Library\r\"
expect "#"
send \"sleep 2s\r\"
expect "#"
send \"exit\r\"
expect \"dummy expect\"
"
clear

read -p "SMS can be encrypted, do you want to encrypt your messages? (Y/N): " ECSMS
if [ "$ECSMS" == "Y" ]; then
    echo "This program will NOT SAVE your encrypted password, or know your password. If you lost it, you will have to Brute-force to unzip the messages."
    sleep 4s
    cd ~/Documents/RestoreAll
    echo "Compressing messages (F is tar.gz)"
    tar -zcvf SMS-E.tar.gz Library/SMS
    clear
    echo "Encrypting messages. Please type your password for zip."
    zip -er SMS-E.tar.gz.zip SMS-E.tar.gz
    echo "Removing the decrypted version"
    rm -rf SMS-E.tar.gz
    rm -rf Library/SMS
    echo "Done"
else
    echo "Compressing messages (F is tar.gz)"
    tar -zcvf SMS-E.tar.gz Library/SMS
    rm -rf SMS
    echo "Done"
fi
rm -rf ~/Documents/RAlock

if [ "$SSHIP" == "localhost" ]; then
    killall itnl
    exit
else
    exit
fi
;;

esac
}
HelloMenu
;;

2)
clear
read -p "It is unlawful to restore any person's data to any phone that is not owned by that person. By pressing enter, you are agree that you read this agreement and agree that the developer doesn't have any responsiblity for any issues that have been caused because of this feature."

clear
Restore_Menu () {

echo "DO NOT TERMINATE THE SESSION DURING THE RESTORE!!!"
echo ""
echo "2A. Restore Photos"
echo "2B. Restore Cydia packages"
echo "2C. Restore Library"
echo "2D. Restore All"
echo ""
echo "Q. Quit"

read RCHOICE

case "$RCHOICE" in

2A)
mkdir RAlock

echo "Removing existing folders to avoid conflicts"
expect -c"
spawn ssh root@$SSHIP -p $PORT -oStrictHostKeyChecking=no -oConnectTimeout=20
expect \"root@$SSHIP's password:\"
stty -echo
send \"$SSHROOT\r\"
stty echo
expect "#"
send \"cd /var/mobile/Media/\r\"
expect "#"
send \"rm -rf DCIM\r\"
expect "#"
send \"rm -rf PhotoData\r\"
expect "#"
send \"exit\r\"
expect \"dummy expect\"
"

echo "Restoring photos and videos"
cd ~/Documents/RestoreAll/PhotosBackUp
expect -c"
spawn scp -P $PORT -o StrictHostKeyChecking=no -o ConnectTimeout=20 -r DCIM root@$SSHIP:/var/mobile/Media/
expect \"root@$SSHIP's password:\"
stty -echo
send \"$SSHROOT\r\"
stty echo
set timeout -1
expect eof
"

expect -c"
spawn scp -P $PORT -o StrictHostKeyChecking=no -o ConnectTimeout=20 -r PhotoData root@$SSHIP:/var/mobile/Media/
expect \"root@$SSHIP's password:\"
stty -echo
send \"$SSHROOT\r\"
stty echo
set timeout -1
expect eof
"

rm -rf ~/Documents/RAlock

if [ "$SSHIP" == "localhost" ]; then
    killall itnl
    exit
else
    exit
fi
;;

2B)
echo "Restoring Cydia packages"
cd ~/Documents/RestoreAll
expect -c"
spawn scp -P $PORT -o StrictHostKeyChecking=no -o ConnectTimeout=20 cydia-tweak.txt root@$SSHIP:/var/mobile
expect \"root@$SSHIP's password:\"
stty -echo
send \"$SSHROOT\r\"
stty echo
expect \"dummy expect\"
"

expect -c"
spawn scp -P $PORT -o StrictHostKeyChecking=no -o ConnectTimeout=20 -r sources.list.d root@$SSHIP:/etc/apt/
expect \"root@$SSHIP's password:\"
stty -echo
send \"$SSHROOT\r\"
stty echo
expect \"dummy expect\"
"

# Again, killing Cydia
expect -c"
spawn ssh root@$SSHIP -p $PORT -o StrictHostKeyChecking=no -o ConnectTimeout=20
expect \"root@$SSHIP's password:\"
stty -echo
send \"$SSHROOT\r\"
stty echo
expect "#"
send \"cd /var/mobile\r\"
expect "#"
send \"killall Cydia\r\"
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
set timeout -1
expect eof
send \"exit\r\"
expect \"dummy expect\"
"
echo ""
echo "Please reboot your device!"

if [ "$SSHIP" == "localhost" ]; then
    killall itnl
    exit
else
    exit
fi
;;

2C)
clear
L_Menu () {
echo "Things with [*] is broken"

echo "AA. Restore Address Book*"
echo "BB. Restore Calander*"
echo "CC. Restore Call History*"
echo "DD. Restore Notes*"
echo "EE. Restore Safari bookmark(s) (Make sure your iCloud sync is off for restore)"
echo "FF. Restore SMS"
echo "GG. Restore Voicemail*"

read LIBC

case "$LIBC" in

AA)
;;

BB)
;;

CC)
;;

DD)
;;

EE)
echo "Killing Safari"
expect -c"
spawn ssh root@$SSHIP -p $PORT -oStrictHostKeyChecking=no -oConnectTimeout=20
expect \"root@$SSHIP's password:\"
stty -echo
send \"$SSHROOT\r\"
stty echo
expect "#"
send \"killall MobileSafari\r\"
expect "#"
send \"exit\r\"
expect \"dummy expect\"
if [ "$SSHIP" == "localhost" ]; then
    killall itnl
    exit
else
    exit
fi
"

echo "Removing existing folders to avoid conflicts"
expect -c"
spawn ssh root@$SSHIP -p $PORT -oStrictHostKeyChecking=no -oConnectTimeout=20
expect \"root@$SSHIP's password:\"
stty -echo
send \"$SSHROOT\r\"
stty echo
expect "#"
send \"cd /var/mobile/Library/\r\"
expect "#"
send \"rm -rf Safari\r\"
expect "#"
send \"exit\r\"
expect \"dummy expect\"
"

echo "Restoring Safari bookmark(s)"
cd ~/Documents/RestoreAll/Library
expect -c"
spawn scp -P $PORT -o StrictHostKeyChecking=no -o ConnectTimeout=20 -r Safari root@$SSHIP:/var/mobile/Library
expect \"root@$SSHIP's password:\"
stty -echo
send \"$SSHROOT\r\"
stty echo
set timeout -1
expect eof
"
if [ "$SSHIP" == "localhost" ]; then
    killall itnl
    exit
else
    exit
fi
;;

FF)
clear
cd ~/Documents/RestoreAll
if [ -f SMS-E.tar.gz.zip ]; then
    echo "Decrypting..."
    unzip SMS-E.tar.gz.zip
    read -p "Messages in your phone will be overwritten. If you have to back it up, back it up right now. (Press enter to continue)"
    tar -zxf SMS-E.tar.gz
    expect -c"
    spawn scp -P $PORT -o StrictHostKeyChecking=no -o ConnectTimeout=20 -r Library root@$SSHIP:/var/mobile/
    expect \"root@$SSHIP's password:\"
    stty -echo
    send \"$SSHROOT\r\"
    stty echo
    set timeout -1
    expect eof
    "
    echo ""
    echo "Please reboot your device!"
    exit
else
    read -p "Messages in your phone will be overwritten. If you have to back it up, back it up right now. (Press enter to continue)"
    tar -zxf SMS-E.tar.gz
    expect -c"
    spawn scp -P $PORT -o StrictHostKeyChecking=no -o ConnectTimeout=20 -r Library root@$SSHIP:/var/mobile/
    expect \"root@$SSHIP's password:\"
    stty -echo
    send \"$SSHROOT\r\"
    stty echo
    set timeout -1
    expect eof
    "
fi

if [ "$SSHIP" == "localhost" ]; then
    killall itnl
    exit
else
    exit
fi
echo ""
echo "Please reboot your device!"
exit
;;

GG)
echo "Killing Phone app"
expect -c"
spawn ssh root@$SSHIP -p $PORT -oStrictHostKeyChecking=no -oConnectTimeout=20
expect \"root@$SSHIP's password:\"
stty -echo
send \"$SSHROOT\r\"
stty echo
expect "#"
send \"killall MobileSafari\r\"
expect "#"
send \"exit\r\"
expect \"dummy expect\"
"

echo "Removing existing folders to avoid conflicts"
expect -c"
spawn ssh root@$SSHIP -p $PORT -oStrictHostKeyChecking=no -oConnectTimeout=20
expect \"root@$SSHIP's password:\"
stty -echo
send \"$SSHROOT\r\"
stty echo
expect "#"
send \"cd /var/mobile/Library/\r\"
expect "#"
send \"rm -rf Voicemail\r\"
expect "#"
send \"exit\r\"
expect \"dummy expect\"
"

echo "Restoring Voicemail"
cd ~/Documents/RestoreAll/Library
expect -c"
spawn scp -P $PORT -o StrictHostKeyChecking=no -o ConnectTimeout=20 -r Voicemail root@$SSHIP:/var/mobile/Library
expect \"root@$SSHIP's password:\"
stty -echo
send \"$SSHROOT\r\"
stty echo
set timeout -1
expect eof
"
if [ "$SSHIP" == "localhost" ]; then
    killall itnl
    exit
else
    exit
fi
;;

esac
}
L_Menu
;;

2D)
echo "Removing existing folders to avoid conflicts"
expect -c"
spawn ssh root@$SSHIP -p $PORT -oStrictHostKeyChecking=no -oConnectTimeout=20
expect \"root@$SSHIP's password:\"
stty -echo
send \"$SSHROOT\r\"
stty echo
expect "#"
send \"cd /var/mobile/Media/\r\"
expect "#"
send \"rm -rf DCIM\r\"
expect "#"
send \"rm -rf PhotoData\r\"
expect "#"
send \"exit\r\"
expect \"dummy expect\"
"

echo "Restoring photos and videos"
cd ~/Documents/RestoreAll/PhotosBackUp
expect -c"
spawn scp -P $PORT -o StrictHostKeyChecking=no -o ConnectTimeout=20 -r DCIM root@$SSHIP:/var/mobile/Media/
expect \"root@$SSHIP's password:\"
stty -echo
send \"$SSHROOT\r\"
stty echo
set timeout -1
expect eof
"

expect -c"
spawn scp -P $PORT -o StrictHostKeyChecking=no -o ConnectTimeout=20 -r PhotoData root@$SSHIP:/var/mobile/Media/
expect \"root@$SSHIP's password:\"
stty -echo
send \"$SSHROOT\r\"
stty echo
set timeout -1
expect eof
"

sleep 1s

echo "Restoring Cydia packages"
cd ~/Documents/RestoreAll
expect -c"
spawn scp -P $PORT -o StrictHostKeyChecking=no -o ConnectTimeout=20 cydia-tweak.txt root@$SSHIP:/var/mobile
expect \"root@$SSHIP's password:\"
stty -echo
send \"$SSHROOT\r\"
stty echo
expect \"dummy expect\"
"

expect -c"
spawn scp -P $PORT -o StrictHostKeyChecking=no -o ConnectTimeout=20 -r sources.list.d root@$SSHIP:/etc/apt/
expect \"root@$SSHIP's password:\"
stty -echo
send \"$SSHROOT\r\"
stty echo
expect \"dummy expect\"
"

# Again, killing Cydia
expect -c"
spawn ssh root@$SSHIP -p $PORT -P $PORT -o StrictHostKeyChecking=no -o ConnectTimeout=20
expect \"root@$SSHIP's password:\"
stty -echo
send \"$SSHROOT\r\"
stty echo
expect "#"
send \"cd /var/mobile\r\"
expect "#"
send \"killall Cydia\r\"
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
set timeout -1
expect eof
send \"exit\r\"
expect \"dummy expect\"
"

clear

cd ~/Documents/RestoreAll
if [ -f SMS-E.tar.gz.zip ]; then
    echo "Decrypting..."
    unzip SMS-E.tar.gz.zip
    read -p "Messages in your phone will be overwritten. If you have to back it up, back it up right now. (Press enter to continue)"
    tar -zxf SMS-E.tar.gz
    expect -c"
    spawn scp -P $PORT -o StrictHostKeyChecking=no -o ConnectTimeout=20 -r Library root@$SSHIP:/var/mobile/
    expect \"root@$SSHIP's password:\"
    stty -echo
    send \"$SSHROOT\r\"
    stty echo
    set timeout -1
    expect eof
    "
    exit
else
    read -p "Messages in your phone will be overwritten. If you have to back it up, back it up right now. (Press enter to continue)"
    tar -zxf SMS-E.tar.gz
    expect -c"
    spawn scp -P $PORT -o StrictHostKeyChecking=no -o ConnectTimeout=20 -r Library root@$SSHIP:/var/mobile/
    expect \"root@$SSHIP's password:\"
    stty -echo
    send \"$SSHROOT\r\"
    stty echo
    set timeout -1
    expect eof
    "
    exit
fi

if [ "$SSHIP" == "localhost" ]; then
    killall itnl
    exit
else
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