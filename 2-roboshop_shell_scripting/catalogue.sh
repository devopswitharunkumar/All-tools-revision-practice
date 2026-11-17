#!/bin/bash

ID=$(id -u)
MONGODB_HOST=mongodb.devopswitharun.online

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

dnf module disable nodejs -y &>> LOG_FILE
check_status $? "disabled"

dnf module enable nodejs:18 -y &>> LOG_FILE
check_status $? "enabled"

dnf install nodejs -y &>> LOG_FILE
check_status $? "nodejs install"

id roboshop &>> LOG_FILE
if [ $? -eq 0 ];then 
    echo -e "$Y user already exists $N"
else 
    useradd roboshop &>> LOG_FILE
    check_status $? "new user created"
fi

mkdir -p /app &>> LOG_FILE
check_status $? "directory created"

curl -L -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip &>> LOG_FILE
check_status $? "downloaded code"

cd /app &>> LOG_FILE

unzip -o /tmp/catalogue.zip &>> LOG_FILE
check_status $? "unzip"

cd /app &>> LOG_FILE

npm install &>> LOG_FILE
check_status $? "install dependencies"

cp catalogue.service /etc/system/system/catalogue.service &>> LOG_FILE
check_status $? "copied service file"

systemctl daemon-reload &>> LOG_FILE
check_status $? "daemon-reload"

systemctl enable catalogue &>> LOG_FILE
check_status $? "catalogue enable"

systemctl start catalogue &>> LOG_FILE
check_status $? "start catalogue"

cp mongo.repo /etc/yum.repos.d/mongo.repo &>> LOG_FILE
check_status $? "copy mongo repo"

dnf install mongodb-org-shell -y &>> LOG_FILE
check_status $? "install mongodb client"

mongo --host "$MONGODB_HOST" </app/schema/catalogue.js &>> LOG_FILE
check_status $? "Schema loaded"