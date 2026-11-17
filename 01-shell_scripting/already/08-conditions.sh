#!/bin/bash

number=$1

if [ $number -gt 100 ]
then
    echo "Given number $number is greater than 100"
else
    echo "Given number $number is less than 100"
fi