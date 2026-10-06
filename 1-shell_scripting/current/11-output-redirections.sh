#!/bin/bash

#Question: install mysql git and nginx

ID=$(id -u)

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

Timestamp=$(date +%F-%H-%M-%S)
LOG_FILE=/tmp/$0-$Timestamp.log

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

dnf install mysql -y &>> $LOG_FILE
check_status $? "Install mysql"

dnf install git -y &>> $LOG_FILE
check_status $? "Install git"

dnf install nginx -y &>> $LOG_FILE
check_status $? "Install nginx"