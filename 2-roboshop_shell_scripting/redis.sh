#!/bin/bash

ID=$(id -u)

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

Timestamp=$(date +%F-%H-%M-%S)
LOG_FILE=/tmp/$0-$Timestamp.log

if [ $ID -eq 0 ];then
    echo -e "$G You are a root user..pls continue $N"
else
    echo -e "$R ERROR : You are Not a root user..pls get the access $N"
    exit 1
fi

check_status(){
    if [ $1 -eq 0 ];then
        echo -e "$G $2 successfull $N"
    else
        echo -e "$R ERROR : $2 failed $N"
        exit 1
    fi 
}

dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>> LOG_FILE
check_status $? "install redis rpm"

dnf module enable redis:remi-6.2 -y &>> LOG_FILE
check_status $? "enable redis module"

dng install redis -y &>> LOG_FILE
check_status $? "install redis"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis/redis.conf &>> LOG_FILE
check_status $? "change access"

systemctl enable redis &>> LOG_FILE
check_status $? "enable redis"

systemctl restart redis &>> LOG_FILE
check_status $? "restart redis"