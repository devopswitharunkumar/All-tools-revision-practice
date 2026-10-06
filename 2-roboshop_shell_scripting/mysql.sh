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


dnf module disable mysql -y &>> LOG_FILE
check_status $? "disable"

cp mysql.repo /etc/yum.repos.d/mysql.repo &>> LOG_FILE
check_status $? "copy repo file"

dnf install mysql-community-server -y &>> LOG_FILE
check_status $? "install mysql"

systemctl enable mysqld &>> LOG_FILE
check_status $? "enable"

systemctl start mysqld &>> LOG_FILE
check_status $? "start"

mysql_secure_installation --set-root-pass RoboShop@1 &>> LOG_FILE
check_status $? "check reset password"

mysql -uroot -pRoboShop@1 &>> LOG_FILE
check_status $? "login to mysql db"