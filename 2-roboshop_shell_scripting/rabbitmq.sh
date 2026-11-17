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

curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>> LOG_FILE
check_status $? "download rpm package of rpm erlang"


curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>> LOG_FILE
check_status $? "download rpm package of rpm rabbitmq server"


dnf install rabbitmq-server -y &>> LOG_FILE
check_status $? "install rabbitmq-server"

systemctl enable rabbitmq-server &>> LOG_FILE
check_status $? "enable rabbitmq-server"

systemctl start rabbitmq-server &>> LOG_FILE
check_status $? "install rabbitmq-server"


rabbitmqctl add_user roboshop roboshop123 &>> LOG_FILE
check_status $? "create user for rabbitmq-server"

rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>> LOG_FILE
check_status $? "setting up permisiions for rabbitmq user"
