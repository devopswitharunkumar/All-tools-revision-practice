#!/bin/bash 

#for loop using list
for i in dev pre-prod prod 
do 
    echo "This is $i Env"
done 

env=("dev" "pre-prod" "prod")
for i in ${env[@]}
do 
    echo "This is $i Env"
done

#for loop using numbers 
for ((i=1;i<=5;i++))
do 
    echo "$i"
done

for i in {1..5}
do 
    echo "$i"
done 

#while loop 
i=1
while [ $i -le 5 ]
do 
    echo "$i"
    i=$((i + 1))
done 

#until loop 
j=2
until [ $j -gt 5 ]
do 
    echo "$j"
    j=$((j + 1))
done 


break 
for i in {1..10}
do 
    if [ $i -gt 5 ];then
        break ;
    fi
    echo "$i"
done

#continue
for i in {1..10}
do 
    if [ $i -eq 5 ];then 
        continue;
    fi 
    echo $i
done 