#!/bin/bash

usage() {
	cat <<- EOF
	
	Usage: merge -m (fichier.pdf) (fichier2.pdf)
	    -h,		affiche cette interface d'aide
	    -m,		-m suivi de 2 fichiers au format pdf.
	EOF
}

# Vérifier si l'utilisateur a fourni au moins un fichier PDF en argument
if [ $# -lt 1 ]; then
  zenity --error --text "Veuillez fournir au moins un fichier PDF en argument."
  exit 1
fi

# Vérifier si tous les fichiers fournis en argument sont bien des fichiers PDF
for file in "$@"; do
  if [[ ! $file =~ .*\.pdf$ ]]; then
    zenity --error --text "Tous les fichiers doivent être au format PDF."
    exit 1
  fi

  # Vérifier si les fichiers existent
  if [ ! -f "$file" ]; then
    zenity --error --text "Le fichier $file n'existe pas."
    exit 1
  fi
done

while getopts "h:" option; do
	case $option in
		h)
			usage
			exit;;
		m)
			
		\?)
			usage
			exit;;
	esac
done


# Afficher une boîte de dialogue pour demander le nom du fichier final
output_filename=$(zenity --file-selection --save --confirm-overwrite --title "Choisissez le nom du fichier final")

# Vérifier si l'utilisateur a annulé ou s'il y a eu une erreur
if [ $? -ne 0 ]; then
  zenity --error --text "Erreur lors de la demande du nom du fichier final."
  exit 1
fi

# Vérifier si l'extension du fichier final est bien .pdf
if [[ ! $output_filename =~ .*\.pdf$ ]]; then
  zenity --error --text "Le fichier final doit avoir l'extension .pdf."
  exit 1
fi

# Construire la liste des fichiers à fusionner en utilisant l'opérateur ";" comme séparateur
files_to_merge=$(printf " %s;" "${@}" | sed 's/;$//')

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

exit 0

