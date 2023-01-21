#!/usr/bin/env bash
#
# Permet d'associer plusieurs pdf en les passant comme argument 

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



usage() {
	cat <<- EOF
	
	Usage: pdfmerge -m (fichier.pdf) (fichier2.pdf) ...
	    -h,		affiche cette interface d'aide
	    -m,		-m suivi de vos fichiers au format pdf.
	EOF
}

if [ $# -eq 0 ];then
	usage
	exit;
fi

while getopts ":m:h" option; do
	case $option in
		h)
			usage
			exit;;
		m)
					
		output_filename=$(zenity --file-selection --save --confirm-overwrite --title "Choisissez le nom du fichier final")

		# Vérifier si l'extension du fichier final est bien .pdf
		if [[ ! $output_filename =~ .*\.pdf$ ]]; then
  			zenity --error --text "Le fichier final doit avoir l'extension .pdf."
  			exit 1
		fi
		# Construire la liste des fichiers à fusionner 
		files_to_merge=$(printf "%s " "${@:2}" | sed 's/;$//')

		# Afficher une boîte de dialogue pour confirmer la fusion
		zenity --question --text "Voulez-vous vraiment fusionner les fichiers suivants : $files_to_merge ?"
		if [ $? -ne 0 ]; then
		# L'utilisateur a annulé
		exit 0
		fi

		# Exécuter la commande pdfunite
		pdfunite $files_to_merge $output_filename

		# Vérifier si la commande s'est exécutée avec succès
		if [ $? -ne 0 ]; then
		zenity --error --text "Erreur lors de la fusion des fichiers."
		exit 1
		fi

		# Afficher une boîte de dialogue pour indiquer la réussite de la fusion
		zenity --info --text "Fusion réussie ! Le fichier final se trouve ici : $output_filename"

		exit 0;;
		\?)
			usage
			exit;;
	esac
done





