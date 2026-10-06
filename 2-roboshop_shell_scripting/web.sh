#!/bin/bash

ID=$(id -u)
MONGODB_HOST=user.devopswitharun.online

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

dnf install nginx -y &>> LOG_FILE
check_status $? "install nginx"

systemctl enable nginx &>> LOG_FILE
check_status $? "enable nginx"

systemctl start nginx &>> LOG_FILE
check_status $? "start nginx"

rm -rf /usr/share/nginx/html/* &>> LOG_FILE
check_status $? "remove nginx default content"

curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip &>> LOG_FILE
check_status $? "download web content"

cd /usr/share/nginx/html/ &>> LOG_FILE

unzip -o /tmp/web.zip &>> LOG_FILE
check_status $? "unzip web content"

cp roboshop.conf /etc/nginx/default.d/roboshop.conf &>> LOG_FILE
check_status $? "copy conf file"

systemctl start nginx &>> LOG_FILE
check_status $? "start nginx"