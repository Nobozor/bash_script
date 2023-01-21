#! /usr/bin/env bash

# Release: 1.0 of 2023/01/05
# 2023, Maxime MONET
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU  General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.



help(){
	printf "usage : psx -a <phrase>\n" 
	
}

if [ $# -eq 0 ];then #Si aucun argument, affiche help
	help
	exit;
fi

error_pas_de_processus(){
	if [ pgrep -a $2 == "" ];then
		printf "error !"
	fi
}

while getopts ":ak:h" option; do
	case $option in 
		a)
			pgrep -a $2 
			if [ $? -eq 1 ];then
				printf "Pas de processus correspondant\n" exit;
			fi; 
			read -p "voulez vous tuer ces processus ? (y/n) " response
			if [ $response == "y" ];then
				pkill -e $2
			else
				echo "GOODBYE !"
				exit;
			fi;;
	
		h)
			help
			exit;;
		\?)	
			printf "error invalid argument -h to help\n"
			exit;;
	esac
done
	


