#!/bin/bash 

ID=$(id -u)         #if root user returns 0

if [ $ID -ne 0 ];then
    echo "you are not a root user. pls run with root user"
else 
    echo "You are a root user"
fi 

dnf install git -y
if [ $? -ne 0 ];then    
    echo "Error while installing"
    exit 1
else
    echo "Installed successfully"
fi 

dnf install mysql -y 
if [ $? -eq 0 ];then
    echo "installed successfully"
else
    echo "Error while installing"
    exit 1
fi 

