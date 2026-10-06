#!/bin/bash

#String variables
name="Arun"
echo "Hello $name"

#number and arithematic variables
a=10
b=20
count=$((a+b))                  #-- must be double braces 
echo "Count is : $count"
echo "Count added is : $((count+5))"

#command variables
current_date=$(date)                #must be braces
echo "Current data is : $current_date"

#env variables 
HOME="/app"
echo "path is : $HOME"

#export variables 
#run this command country=india in terminal or put this in 01-Hello-world.sh
export country
echo "Country is $country"

#variable data externsion
Course="shell_script"
echo "${Course} learning"       #o/p : shell_script learning

#local variable
deploy() {
    env=dev
    echo "environment is $env"
}
deploy 

#global variable
env=dev
deploy() {
    echo "environment is global $env"
    echo "country is $country"
}
deploy 

#read 
echo "What's you name.. Pls enter your name below"
read name
echo "My name is : $name"


read -p "Pls enter environment name : " env
echo "Env is $env"

echo "Pls enter your password below"
read -s password
echo "Password is $password"

#combination -p and -s 
read -s -p "Pls enter your password : " password
echo "Password is $password"

#Default values 
name="kumar"                    #if u provide o/p: is kumar but if u give "" empty op is Arun
echo "Name is ${name:-Arun}"                #default value 