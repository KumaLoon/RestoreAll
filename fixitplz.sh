#!/bin/bash

# Not even beta, not even tested yet

if [ -d /var/mobile/Assests ]; then
echo "Fixing Library"
rm -rf Library/Assets
mv Assets /var/mobile/Library
clear
else
clear
fi

if [ -d /var/mobile/Caches ]; then
echo "Fixing Library"
rm -rf Library/Caches
mv Caches /var/mobile/Library
clear
else
clear
fi

if [ -d /var/mobile/DCIM ]; then
else
clear
echo "You have to re-run 'Restore Photos'"
sleep 10s
clear
fi

if [ -d /var/mobile/PhotoData ]; then
else
clear
echo "You have to re-run 'Restore Photos'. If you are running iOS 9, just ignore this."
sleep 10s
clear
fi

if

exit 0