#!/usr/bin/env bash

temp=$XDG_RUNTIME_DIR

#### COLOR ####
red='\033[31m'
reset='\033[0m'
bg_blue='\033[44m'


####

help(){
	printf "Usage : \nytdl -u [url]\n"
}


if  [ $# -eq 0 ];then
	help
	exit;
fi
	

while getopts ":uh" option; do
	case $option in
		u)
			url=$2;;
		h)
			help
			exit;;
		\?)
			printf "Error invalid argument -h to help\n"
			exit;;
	esac
done


if yt-dlp -F $url &> /dev/null
	then

	## Téléchargement de l'audio 
	printf "$bg_blue CHOIX DU FORMAT AUDIO$reset\n"
	yt-dlp -F $url |grep "audio only" 
	read -p "give me ID code to download >> " format_code
	yt-dlp -f $format_code -o $temp/audio.%\(ext\)s $url
	
	## Téléchargement de la vidéo
	printf "$bg_blue CHOIX DU FORMAT VIDEO$reset\n"
	yt-dlp -F $url |grep "video only" 2> /dev/null
	read -p "give me ID code to download >> " format_code
	yt-dlp -f $format_code -o $temp/video.%\(ext\)s $url

	## Merge audio / vidéo 

	ffmpeg -i $temp/audio.* -i $temp/video.* -c copy merged_video.mp4 &> /dev/null

	## CLEAN LE DOSSIER TEMP
	rm $temp/audio.* $temp/video.*	
else
	printf "URL incorrect\n"
fi 
