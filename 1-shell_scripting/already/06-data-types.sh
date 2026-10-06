#!/bin/bash

NUMBER1=$1
NUMBER2=$2

echo "Total amount is  $(($NUMBER1 + $NUMBER2))" 

echo "All args passed : $@"
echo "no of args passed : $#"
echo "script name : $0"
echo "exit status : $?"