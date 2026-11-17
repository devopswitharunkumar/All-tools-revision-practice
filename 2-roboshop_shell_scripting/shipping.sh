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


dnf install maven -y &>> LOG_FILE
check_status $? "install maven"

id roboshop &>> LOG_FILE
if [ $? -eq 0 ];then
    echo "User already exists"
else 
    useradd roboshop &>> LOG_FILE
    check_status $? "creating user"
    echo "user creating"
fi 

mkdir -p /app &>> LOG_FILE
check_status $? "create app"

curl - L -o /tmp/shipping.zip https://roboshop-builds.s3.amazonaws.com/shipping.zip &>> LOG_FILE
check_status $? "download shipping zip file"

cd /app

unzip -o /tmp/shipping.zip &>> LOG_FILE
check_status $? "unzip shipping"

cd /app 

mvn clean package &>> LOG_FILE
check_status $? "install dependencies"

mv target/shipping-1.0.jar shipping.jar &>> LOG_FILE
check_status $? "rename shipping jar"

cp shipping.service /etc/systemd/system/shipping.service &>> LOG_FILE
check_status $? "copy service"

systemctl daemon-reload &>> LOG_FILE
check_status $? "system reload"

systemctl enable shipping &>> LOG_FILE
check_status $? "enable shipping"

systemctl start shipping &>> LOG_FILE
check_status $? "start shipping"

dnf install mysql -y &>> LOG_FILE
check_status $? "install mysql client"

mysql --host <mysql ec2 ip> </app/schema/shipping.sql &>> LOG_FILE
check_status $? "load schema"

systemctl restart shipping &>> LOG_FILE
check_status $? "restart shipping"