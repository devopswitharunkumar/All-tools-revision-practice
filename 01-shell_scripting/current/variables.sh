#!/bin/bash 

# #string 
# name="Arun"
# echo "Hello Arun"

# #number 
# a=10
# result=$((a + 5))
# echo "$result"

# #arithematic 
# a=10
# b=20
# echo "$((a + b))"

# #command substitution
# current_date=$(date)
# echo "Today's date is : $current_date"

# #env variables 
# env=dev
# HOME="/app/config"
# echo "$HOME and $env"

# #export variables 
# export name     #--> given in 01-Hello-world.sh file 
# echo "Hello, I already exported $name"

# #combile value 
# name=kumar
# echo "${name} is ready" 
# echo "${name}"  reddy

# #local
# deploy(){
#     name=Arun
#     echo "Hello Arun"
# }
# deploy

# #global
# name=Arun
# deploy(){
#     echo "Hello Arun"
# }
# deploy

# #read variables 
# #only read
# echo "Enter ur name below"
# read name
# echo "Hello $name"

# #promt + read
# read -p "Enter ur name :" name
# echo "Hello $name"

# #characters not visible on the terminal 
# read -s password
# echo "Enter ur password : $password"

# #combination
# read -s -p "Enter password: " password

# #default values 
# name=""
# echo "Hello ${name:-Arun}"

#required variables 
env=""
echo "${env:? Environment variable value required}"