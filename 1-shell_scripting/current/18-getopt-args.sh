#!/bin/bash
# NAME=""
# WISHES="Good Evening"

USAGE(){
    echo "Usage : $(basename "$0") [ -n name ] [ -w wishes ] [ -h ]"
	echo ""
	echo "Options:"
	echo "-n 	specify the name (mandatory)"
	echo "-w 	specify the wish (Optional)"
	echo "-h 	Display the help"
}
while getopts ":n:w:h" anyvariablename
do
	case $anyvariablename in
		n) NAME="$OPTARG" ;;
		w) WISHES="$OPTARG" ;;
		-h) USAGE 
			exit  1 ;;
		:)	echo "ERROR : -$OPTARG requires a value"
			USAGE
			exit 1 ;; 
		\?)	echo "ERROR : invalid option -$OPTARG "
			USAGE
			exit 1 ;; 
	esac
done 

if [ -z "$NAME" ];then
	echo "ERROR  : -n is mandatory"
	USAGE
	exit 1 
fi 

echo "HI $NAME, $WISHES"