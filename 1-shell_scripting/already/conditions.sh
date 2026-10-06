#!/bin/bash

#Numeric conditions : -eq, -ne, -gt, -lt, -ge, -le

number=101
if [ $number -gt 100 ];then
    echo "Given number is greater than 100"
elif [ $number -lt 100 ];then
    echo "Given number is less than 100"
else 
    echo "not greater than or lessthan"
fi 

age=10
if [ $age -ge 20 ];then 
    echo "Given age is greater than or equal to 20"
elif [ $age -le 20 ];then
    echo "Given age is less than or equal to 20"
else    
    echo "not greater than or lessthan"
fi 

exact_age=30 
if [ $exact_age -eq 20 ];then                     #space must before and after =
    echo "Given age is equal to 20"
elif [ $exact_age -ne 20 ];then
    echo "Given age is not equal to 20"
else    
    echo "not both"
fi 

# Inside the standard [ ] (test) brackets, the shell relies entirely on spaces to understand what you are comparing
# -- if u dont provide space shell treates $exact_age=20 as single text, In shell scripts, any non-empty string inside brackets automatically evaluates to true
#  the if statement thinks the condition passed.

#String conitions : = , != , -z (string is empty) , -n (string is non empty)

env=dev
if [ "$env" = "dev" ];then        #space must before and after =
    echo "Correct Env"
else    
    echo "Diff Env loaded"
fi

env=prod
if [ "$env" != "dev" ];then        #space must before and after =
    echo "Correct Env not equal"
fi

Env=""
if [ -z $Env ];then
    echo "Env value is empty"
elif [ -n $Env ];then
    echo "Env value is not empty string has characters"
else
    echo "nothing"
fi

#operators conditions

name=Arun                         
country=india
if [ "$name" = "Arun" ] && [ "$country" = "india" ];then            #space must before and after =
    echo "name and country both details are correct"
elif [ "$name" = "Arun" ] || [ "$country" = "japan" ];then
    echo "name and country one value is correct"
else
    echo "Both are incorrect"
fi

#file conditions: 

if [ -f "./app/config.txt" ];then
    echo "file exists"
fi

if [ -d "./app/" ];then
    echo "dir exists"
fi

if [ -e "./app/" ];then
    echo "dir exists"
fi

if [ -s "./app/config.txt" ];then
    echo "file exists and "
fi


#in this case normally it satisfies both -f and -d because dir exists and file exists but 0f conition will be satisfied already so it wont check other command so o/p : file exists
if [ -f "./app/config.txt" ]; then
    echo "file exists"
elif [ -d "./app" ];then
    echo "dir exists"
else 
    echo "both not exists"
fi

if [ -r "./app/config.txt" ]; then
    echo "File is readable"
else 
    echo "file is not readable"
fi 

if [ -w "./app/config.txt" ]; then
    echo "File is writable"
else 
    echo "file is not writable"
fi 

if [ -x "./app/config.txt" ]; then
    echo "File is executable"
else 
    echo "file is not executable"
fi 