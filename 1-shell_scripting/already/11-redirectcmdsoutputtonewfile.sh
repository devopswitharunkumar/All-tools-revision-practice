#!/bin/bash

ID=$(id -u)

if [ $ID -eq 0 ];then
    echo "you are a root user..Pls proceed"
else
    echo "Error : You are not a root user..pls get root access"
    exit 1
fi 

Timestamp=$(date +%F-%H-%M-%S)
LOG_FILE=/tmp/$0-$(Timestamp).log

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

check_function(){
    if [ $1 -eq 0 ];then
        echo -e "$G Successfully installed $2 $N"
    else 
        echo -e "$R Error : Installation failed $2 $N"
        exit 1
    fi 
}

dnf install git -y  &>> LOG_FILE
check_function $? "git" 

dnf install nginx -y    &>> LOG_FILE   
check_function $? "nginx" 

dnf install mysql -y    &>> LOG_FILE
check_function $? "mysql" 