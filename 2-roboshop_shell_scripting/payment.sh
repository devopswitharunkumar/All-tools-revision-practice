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


dnf install python36 gcc python3-devel -y &>> LOG_FILE
check_status $? "install python" 

id roboshop &>> LOG_FILE
if [ $? -eq 0 ];then
    echo "User already exists"
else 
    useradd roboshop &>> LOG_FILE
    check_status $? "creating user"
fi

mkdir -p /app &>> LOG_FILE
check_status $? "create dir" 

curl -o /tmp/payment.zip https://roboshop-builds.s3.amazonaws.com/payment.zip &>> LOG_FILE
check_status $? "download payment zip" 

cd /app &>> LOG_FILE

unzip -o /tmp/payment.zip &>> LOG_FILE
check_status $? "unzip payment code" 

cd /app &>> LOG_FILE

pip3.6 install -r requirements.txt &>> LOG_FILE
check_status $? "install dependencies" 

cp payment.service /etc/systemd/system/payment.service &>> LOG_FILE
check_status $? "copy payment.service" 

systemctl daemon-reload &>> LOG_FILE
check_status $? "reload daemon" 

systemctl enable payment &>> LOG_FILE
check_status $? "enable payment" 

systemctl start payment &>> LOG_FILE
check_status $? "start payment" 