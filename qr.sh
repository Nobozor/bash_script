#! /usr/bin/env bash

help(){
	printf "Usage : qr -c to copy clipboard into qrcode\n"
	printf "Usage : qr -i \"phrase\" \n" 
}

if [ $# -eq 0 ];then #Si aucun argument, affiche help
	help
	exit;
fi

while getopts ":ci:h" option; do
	case $option in
		c)
			qrencode `xclip --selection clipboard -o` -o qrpaste;;
		i)	
			qrencode "$2" -o qrcode;;
		h)
			help
			exit;;
		\?)	
			printf "error invalid argument -h to help\n"
			exit;;
	esac
done
