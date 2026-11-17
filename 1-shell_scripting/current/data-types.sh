#!/bin/bash

#string type
name=Arun
echo "$name"

#number 
a=10
echo "$((a + 5))"

a=10
b=20
echo "$((a + b))"

#float/decimals
a=10.5
b=20.5
# echo "$((a+b | bc))"

#boolean 
env=false
if $env; then
    echo "correct env"
else
    echo "wrong env"
fi 

#Arrays 
fruits=("apple" "banana" "carrot")
echo "1st fruit is : ${fruits[0]}"
echo "2nd fruit is : ${fruits[1]}"
echo "3rd fruit is : ${fruits[2]}"
echo "All fruits  : ${fruits[@]}"
