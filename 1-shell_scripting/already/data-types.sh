#!/bin/bash 

#String type
name=arun
echo "Hello $name"

#number type   --> except number every thing considered as 0 even if u provide word also 
a=10
b=20
c=hbdvs
d=jrhskjv
echo "$((a+b))"     #o/p : 30
echo "$((c+b))"     #o/p : 20       characters considered as 0
echo "$((d+c))"     #o/p : 0        characters considered as 0

#float/decimal type 
a=10.5
b=20.5
# result="$(echo "$a+$b" | bc)"
echo "$result"

#boolean
dev=true
if $dev;then
    echo "This is dev env"
fi 


#Arrays 
fruits=("Apple" "Banana" "car")
echo "1st fruit is ${fruits[0]}"
echo "2nd fruit is ${fruits[1]}"
echo "3rd fruit is ${fruits[2]}"
echo "All fruits are ${fruits[@]}"
