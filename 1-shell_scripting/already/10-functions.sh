#!/bin/bash 

ID=$(id -u)
if [ $ID -eq 0 ];then
    echo "Root user u can continue..."
else
    echo "You are not a root user pls get the access"
    exit 1
fi 

check_status(){
    if [ $1 -eq 0 ]; then 
        echo " $2 is installed Successfully.."
    else 
        echo "Error while installing.. pls check"
        exit 1
    fi
} 

dnf install git -y
check_status $? "Git"

dnf install mysql -y 
check_status $? "Mysql"

