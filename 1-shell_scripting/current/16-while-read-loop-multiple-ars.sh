#!/bin/bash 

File="userdetails/details.txt"

if [ -d "$File" ];then
    echo "dir already exists"
else 
    mkdir -p userdetails
    echo "dir created"
    echo "Arun:PASS:1" > userdetails/details.txt
    cat details.txt 
fi 

pwd
while IFS=":" read -r username password user_id
do 
    echo "username": $username
    echo "password": $password
    echo "user_id": $user_id
done < $File 