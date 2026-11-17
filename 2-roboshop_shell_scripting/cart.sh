#!/bin/bash

ID=$(id -u)
MONGODB_HOST=cart.devopswitharun.online

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

Timestamp=$(date +%F-%H-%M-%S)
LOG_FILE=/tmp/$0-$Timestamp.log

if [ $ID -eq 0 ];then
    echo -e "$G You are a root cart..pls continue $N"
else
    echo -e "$R ERROR : You are Not a root cart..pls get the access $N"
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

dnf module disable nodejs -y &>> LOG_FILE
check_status $? "disabled"

dnf module enable nodejs:18 -y &>> LOG_FILE
check_status $? "enabled"

dnf install nodejs -y &>> LOG_FILE
check_status $? "nodejs install"

id roboshop &>> LOG_FILE
if [ $? -eq 0 ];then 
    echo -e "$Y cart already exists $N"
else 
    useradd roboshop &>> LOG_FILE
    check_status $? "new cart created"
fi

mkdir -p /app &>> LOG_FILE
check_status $? "directory created"

curl -L -o /tmp/cart.zip https://roboshop-builds.s3.amazonaws.com/cart.zip &>> LOG_FILE
check_status $? "downloaded code"

cd /app &>> LOG_FILE

unzip -o /tmp/cart.zip &>> LOG_FILE
check_status $? "unzip"

cd /app &>> LOG_FILE

npm install &>> LOG_FILE
check_status $? "install dependencies"

cp cart.service /etc/system/system/cart.service &>> LOG_FILE
check_status $? "copied service file"

systemctl daemon-reload &>> LOG_FILE
check_status $? "daemon-reload"

systemctl enable cart &>> LOG_FILE
check_status $? "cart enable"

systemctl start cart &>> LOG_FILE
check_status $? "start cart"
