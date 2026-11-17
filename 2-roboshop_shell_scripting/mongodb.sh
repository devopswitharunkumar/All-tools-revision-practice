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

cp mongo.repo /etc/yum.repos.d/mongo.repo  &>> LOG_FILE
check_status $? "copy mongo repo"

dnf install mongodb-org -y &>> LOG_FILE
check_status $? "install mongodb"

systemctl enable mongod &>> LOG_FILE

validate $? "Enabling mongodb"

systemctl start mongod &>> LOG_FILE

validate $? "Starting mongodb"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf &>> LOG_FILE
check_status $? "changed access"

systemctl restart mongod &>> LOG_FILE
check_status $? "restart"