#! /usr/bin/env bash

#Default variables
name=$(basename "$0")
containerName="myContainer";
distribution="debian";
release="buster";
architecture="amd64";

#Function

red() {
    printf "\033[31m$1\033[0m"
}

green() {
    printf "\033[32m$1\033[0m"
}

afficheError(){
	red "Erreur : $1\n" && exit 2;
}

afficheList(){
	echo "not implemented yet";
}


usage() {
	cat <<- EOF
		Usage : $name [--list] [--name NAME] [--distro DISTRO] [--release RELEASE] [--archi ARCHITECTURE] [--help]
                      -n,     --name : name to use for your container (default -> "myContainer")
                      -d,   --distro : distribution to use (default -> debian)
                      -r,  --release : distribution release to user (default -> buster)
                      -a,    --archi : architecture to use (default -> amd64)
                      -l,     --list : affiche la liste des distributions diponible
                      -h,     --help : affiche cette aide
	EOF
}

OPTS=$(getopt -o n:d:r:a:lh --long name:,distro:,release:,archi:,list,help -n "$name" -- "$@") || afficheError "getopt failed with error code : $?" 


while true; do
	case "$1" in
		-n|--name) containerName=$2; shift 2;;
		-d|--distro) distribution=$2; shift 2;;
		-r|--release) release=$2; shift 2;;
		-a|--archi) architecture=$2; shift 2;;
		-l|--list) red "Not implemented yet !\n"; exit 0;;
		-h|--help)usage; exit 0;;
		--) shift break;;
		*) break;;
	esac
done

if sudo lxc-ls | grep $containerName > /dev/null;
then
	afficheError "Container Name incorrect, already in use"
fi



sudo lxc-create -t download -n $containerName -- -d $distribution -r $release -a $architecture --keyserver hkp://keyserver.ubuntu.com
if [ $? != 0 ];
then
	afficheError "container creation failed"
else
	printf "container $containerName succesfully created" && green " [OK] \n"
fi

sudo cat <<- EOF > /var/lib/lxc/$containerName/rootfs/init_script.sh
#! /usr/bin/env bash
sed -i 's/# fr_FR.UTF-8 UTF-8/fr_FR.UTF-8 UTF-8/' /etc/locale.gen
locale-gen --purge fr_FR.UTF-8
update-locale LANG=fr_FR.UTF-8
PATH="\$PATH:/sbin:/usr/sbin"
apt update -y
apt install ssh sudo -y
adduser --disabled-password  --gecos "" user
usermod -aG sudo user
	EOF

if sudo lxc-start $containerName;
then
	printf "container started" && green "[OK]\n"
else
	afficheError "Container start failed"
fi

sleep 6

sudo lxc-attach -n $containerName -- bash -c 'chmod +x init_script.sh; ./init_script.sh' 


