#!/bin/bash 

#for loop for list 
for cars in bmw suzuki hundai
do
    echo "$cars"
done 

cars=("bmw" "suzuki" "hundai")
for car in ${cars[@]}
do 
    echo "$car"
done 

#for loop for numbers
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
    i="$((i +1))"
done

#until loop 
i=1
until [ $i -eq 5 ]
do 
    echo "$i"
    i="$((i +1))"
done

#break 
for i in {1..10}
do 
    if [ $i -eq 5 ];then
        break;
    fi 
    echo "$i"
done 

#continue 
for i in {1..10}
do 
    if [ $i -eq 5 ];then
        continue;
    fi 
    echo "$i"
done 