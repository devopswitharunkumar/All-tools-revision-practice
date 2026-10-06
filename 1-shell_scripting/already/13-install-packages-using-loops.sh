#!/bin/bash

ID=$(id -u)

if [ $ID -ne 0 ]
then    
    echo "You are not a root user pls take root acces"
    exit 1
else
    echo "You are a root user pls proceed"
fi 

Timestamp=$(date +%F-%H-%M-%S)
LOG_FILE=/tmp/$0-$Timestamp.log 

check_function() {
    if [ $1 -eq 0 ];then
        echo "$2 Installed succesfully"
    else
        echo "Error $2 installation failed"
        exit 1
    fi
}

packages=("git" "mysql" "nginx")
for package in ${packages[@]}
do  
    dnf install $package -y
    check_function "$1" "$package"
    echo "installed successfully"
done 