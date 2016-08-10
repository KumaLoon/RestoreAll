#!/bin/bash

if [ -d /var/mobile/Assests ]; then
    echo "Fixing Library"
    rm -rf /var/mobile/Library/Assets
    mv Assets /var/mobile/Library
    clear
    CHECKED="1"
else
    :
fi

if [ -d /var/mobile/Caches ]; then
    echo "Fixing Library"
    rm -rf /var/mobile/Library/Caches
    mv Caches /var/mobile/Library
    clear
    CHECKED="2"
else
    :
fi

if [ -d /var/mobile/DCIM ]; then
    :
else
    clear
    echo "You have to re-run 'Restore Photos'"
    sleep 3s
    clear
    CHECKED="3"
fi

if [ -d /var/mobile/PhotoData ]; then
    :
else
    clear
    echo "You have to re-run 'Restore Photos'. If you are running iOS 9, just ignore this."
    sleep 3s
    clear
    CHECKED="4"
fi

if [ "$CHECKED" == "1" ]| [ "$CHECKED" == "2" ]; then
    echo "You should be good to go."
    exit 0
elif [ "$CHECKED" == "3" ] | [ "$CHECKED" == "4" ]; then
    echo "Please re-run what has been requested."
    exit 0
else
    echo "Nothing is wrong here, why are you here?"
    exit 0
fi