#!/bin/bash

#Question: install mysql git and nginx

ID=$(id -u)

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

Timestamp=$(date +%F-%H-%M-%S)
LOG_FILE=/tmp/$0-$Timestamp.log

exec &>> $LOG_FILE

if [ $ID -eq 0 ];then
    echo -e "$G You are a root user pls continue $N"
else
    echo -e "$R You are not a root access and pls get the root access $N"
    exit 1
fi 

check_status(){
    if [ $1 -eq 0 ];then
        echo -e "$G $2 Success $N"
    else    
        echo -e "$R $2 failed $N"
        exit 1
    fi
}

packages=("mysql" "git" "nginx")
for package in ${packages[@]}
do 
    dnf list installed $package 
    if [ $? -ne 0 ];then 
        dnf install $package -y 
        check_status $? "Install $package"
        echo -e "$G Successfully installed $N"
    else
        echo "$R $package alreay installed $N"
    fi
done 
