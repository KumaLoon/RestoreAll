#!/bin/bash

LOCAL=$( cd $(dirname $0) ; pwd -P )
clear
if [ -d $LOCAL/itnl_rev8 ]
    then
        echo "SSH over USB(itnl_rev8) is developed by msftguy, licensed under New BSD License"
        sleep 2s
        $LOCAL/itnl_rev8/itnl --iport 22 --lport 2222
    else
        cd $LOCAL
        echo "Downloading the SSH over USB script..."
        curl -OL https://iphonetunnel-usbmuxconnectbyport.googlecode.com/files/itnl_rev8.zip
        unzip itnl_rev8.zip
        rm -rf itnl_rev8.zip
        clear
        echo "SSH over USB(itnl_rev8) is developed by msftguy, licensed under New BSD License. If you disagree with the license, exit now."
        sleep 5s
        $LOCAL/itnl_rev8/itnl --iport 22 --lport 2222
fi
exit 