#!/bin/bash
# use this file with the following crontab to check the vpn connection every 5 mins:
# */5 * * * * /path/to/this/file.sh >> /path/to/log/file.log 2>&1

# command to start VPN connection
VPNCOM="systemctl start openvpn@de434u"

# add ip / hostname separated by white space
#HOSTS="1.2.3.4"
HOSTS="8.8.8.8 4.2.2.4"
# no ping request
totalcount=0
COUNT=4

DATE=`date "+%Y-%m-%d %H:%M:%S"`

if ! /sbin/ifconfig tun0 | grep -q "00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00"
then
        echo [$DATE] tun0 down
        sudo $VPNCOM
else

        for myHost in $HOSTS;
        do
                count=`ping -c $COUNT $myHost | grep 'received' | awk -F',' '{ print $2 }' | awk '{ print $1 }'`
                totalcount=$(($totalcount + $count))
        done

        if [ $totalcount -eq 0 ]
        then
                echo [$DATE] "ping failed"
                sudo $VPNCOM
        fi
fi
