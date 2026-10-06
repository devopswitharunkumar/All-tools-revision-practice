#!/bin/bash 

#numeric conditions : -eq, -ne, -ge , -le , -gt , -lt

#-eq, -ne
num=0
if [ $num -eq 0 ];then
    echo "Equals to 0"
elif [ $num -ne 0 ];then 
    echo "Number not equals to 0"
else 
    echo "not a number"
fi 

#-ge, -le
age=17
if [ $age -ge 18 ];then 
    echo "Eligible to vote"
elif [ $age -le 18 ];then  
    echo "Not Eligible to vote"
else
    "Not an indian citizen"
fi 

#-gt, -lt
age=17
if [ $age -gt 18 ];then 
    echo "Eligible to vote"
elif [ $age -lt 18 ];then  
    echo "Not Eligible to vote"
else
    "Not an indian citizen"
fi

#string conditions : = , != , -z - empty string , -n - not empty string 

env=dev
if [ "$env" = "dev" ];then
    echo "This is correct env"
else
    echo "This is wrong env"
fi

env=dev
if [ "$env" != "prod" ];then
    echo "This is correct env"
else
    echo "This is wrong env"
fi

env=""
if [ -z "$env" ];then
    echo "This is empty string"
elif [ -n "$env" ];then
    echo "This is not empty string"
else
    echo "both are not correct"
fi

#multiple conditions 
name="dd"
country=ja

if [ "$name" = "Arun" ] && [ "$country" = "india" ];then
    echo "Details are correct"
elif [ $name = "Arun" ] || [ $country = "japan" ];then
    echo "Some part of details are correct"
else 
    echo "both details are incorrect"
fi 
,
#file conditions : -f, -d , -e, -s, -r, -w, -x

if [ -f "./app/config.log" ];then
    echo "file exists"
fi

if [ -d "./app" ];then
    echo "dir exists"
fi

if [ -e "./app" ];then
    echo "dir exists"
fi 

if [ -e "06-data-types.sh" ];then
    echo "file exists"
fi 

if [ -s "./app/config.log" ];then
    echo "File exixts and file size is gt 0"
fi 

if [ -r "06-data-types.sh" ];then
    echo "file can be readable"
fi

if  [ -w "06-data-types.sh" ];then
    echo "file can be writable"
fi

if [ -x "08-conditions.sh" ];then
    echo "file can executable"
else 
    echo "file cannot executable"
fi 
