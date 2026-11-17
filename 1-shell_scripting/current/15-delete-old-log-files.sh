#!/bin/bash

source_dir="app/shell_logs"

if [ -d "$source_dir" ];then
    echo "dir already exists"
else 
    mkdir -p app/shell_logs
    echo "creating source directory.."
fi

cd app/shell_logs/

touch -d 20260911 old_file1.log
touch -d 20250711 old_file2.log
touch -d 20260923 file3.log
touch -d "10 days ago" file4.log
touch -d "2026-07-11 14:02:45" old_file5.log
touch -d "2024-02-14 13:19:32" old_file6.log
touch -d 20260929 file7.log
touch -d 20260930 file8.log

echo "new log files created.."
pwd
echo "currently in log files folder"
Files_to_delete=$(find . -type f -mtime +14 -iname "*.log")

while IFS= read -r log 
do 
    echo "Deleteing the file: $log"
    if [ -f "$log" ];then
        rm -rf "$log"
        echo "Deleted successfully"
    else 
        echo "file doesn't exists"
    fi
done <<< $Files_to_delete

#or directly u can do below command instead of above code from Files_to_delete
# find app/shell_logs/ -type f -mtime +14 -iname "*.log" -delete