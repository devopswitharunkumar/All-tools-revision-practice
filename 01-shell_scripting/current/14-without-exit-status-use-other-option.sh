$!/bin/bash

set -e 

useradd roboshop        #even this also give if i run script 2nd time and already user exists 

dnf install nginx -y

echo "Before wrong command"

systemctl ena nginx

echo "Before wrong command"

systemctl start nginx 
