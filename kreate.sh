#! /bin/bash
# Author: Michael Buckley <github.com/piCounter>
# Description: Create the base kustomize.yaml file to stdout

show_help() {
	echo 'Usage: kreate.sh [OPTION]...'
    echo -e "\t-a add files and directories"
    echo -e "\t-d add directories only"
    echo -e "\t-f add files only"
    echo -e "\t-h|? show this help message and exit"
    exit 0
}

output_header() {
	echo 'apiVersion: kustomize.config.k8s.io/v1beta1'
	echo 'kind: Kustomization'
	echo 'resources:'
}

output_body() {
	if [[ ! "${1}" == 'kustomize.yaml' ]]; then
		echo "  - ${1}"
	fi
}

add_directories_only() {
	for i in $(ls -p $PWD); do
		if [ -d $i ]; then
			output_body ${i}
		fi
	done
}

add_files_only() {
	for i in $(ls -p $PWD); do
		if [ ! -d $i ]; then
			output_body ${i}
		fi
	done
}
 
add_files_and_directories() {
	for i in $(ls -p $PWD); do
		output_body ${i}
	done
}

# Show help if no arguments are given
if [ $# -eq 0 ]; then
        show_help
        exit 0
fi

# Accept option flags
while getopts "h?dfa" opt; do
	case "$opt" in
		h|\?)
			show_help
			exit 0
			;;
		d)
			output_header 
			add_directories_only
			;;
		f)
			output_header 
			add_files_only
			;;
		a)
			output_header 
			add_files_and_directories
			;;
	esac
done

