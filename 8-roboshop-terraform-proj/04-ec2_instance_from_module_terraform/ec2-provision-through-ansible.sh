#!/bin/bash

sudo yum install ansible -y
cd /home/ec2-user
mkdir -p /tmp/
cd /tmp/
git clone https://github.com/devopswitharunkumar/All-tools-revision-practice.git    
cd All-tools-revision-practice/5-roboshop-ansible-using-roles/

# chown -R ec2-user:ec2-user /home/ec2-user/All-tools-revision-practice

ansible-playbook -e component=mongodb main.yaml
ansible-playbook -e component=redis main.yaml
ansible-playbook -e component=mysql main.yaml
ansible-playbook -e component=rabbitmq main.yaml
ansible-playbook -e component=catalogue main.yaml
ansible-playbook -e component=cart main.yaml
ansible-playbook -e component=user main.yaml
ansible-playbook -e component=shipping main.yaml
ansible-playbook -e component=payment main.yaml
ansible-playbook -e component=web main.yaml

#or u can use loops 

