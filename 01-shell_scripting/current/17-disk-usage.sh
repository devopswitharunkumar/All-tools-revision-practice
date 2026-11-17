#!/bin/bash 

DISK_USAGE=$(df -hT | grep -v 'tmp|File')
DISK_THRESHOLD=1

while IFS=read line 
do 
    usage=$(echo $line | awk '{print $6F}')
    partition=$(echo $line | aws '{print $1F}')
    if [ $usage -ge $DISK_THRESHOLD ];then
        message+="High Disk Usage on $partition: $usage\n"
    fi

done <<< $DISK_USAGE

echo -e "Message : $message"