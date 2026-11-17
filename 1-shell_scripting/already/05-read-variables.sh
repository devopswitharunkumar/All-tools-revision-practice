#!/bin/bash
#scenario 1: 

read name
echo "Hello $name"

#scenario 2 : prompt + read

read -p "Pls enter you course : " coursename
echo "Course is $coursename"

#scenario 3 : silent input used for password basically it doesn't display characters u types 
read -s password
echo "Silent input value : $password"

#scenario 4 : cobine -s and -p 
read -s -p "Pls enter you course : " coursename
echo "Course is $coursename"