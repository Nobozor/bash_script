#!/bin/bash

# Déplace des fichiers dans des dossiers correspondant à leur MIME TYPE

# Release: 1.0 of 2023/01/04
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

# Changelog
# 1.0 --> initial release


help(){
	printf "usage : sort_files -d [directory]\n"
}

# On crée un tableau associatif qui va associer à chaque type de fichier un répertoire
declare -A types
types[audio]="audio_files"
types[video]="video_files"
types[image]="image_files"
types[text]="text_files"
types[application]="application_files"

while getopts ":d:h" option;do
	case $option in
		h)
			help
			exit;;			
		d)
			dir=$2 # On récupère le nom du répertoire à trier
			if [ ! -d "$dir" ] || [ ! -r "$dir" ]; then
                                printf "Error: le repertoire '$dir' n'existe pas ou n'est pas accesible en lecture.\n"
                                exit 1
                        fi
			for file in $(find $dir)
			do
				if [ -f $file ];then
    					# On récupère le type du fichier en utilisant la commande 'file'
    					file_type=$(file --mime-type "$file" | cut -d ':' -f 2 | tr -d ' ')
   					file_type=${file_type%/*}

    					if [[ -v "types[$file_type]" ]]
    					then
        					mkdir -p "${types[$file_type]}"
        					# On renomme le fichier avec le bon nom et l'extension
        					mv "$file" "${types[$file_type]}/${file_name}"
					else 
						mkdir -p "other_files"
						mv "$file" "other_files/${files_name}" 
                        		fi
				fi
			done
			exit;;

		\?)
			printf "error invalid argument -h to help\n"
			exit;;
	esac
done
