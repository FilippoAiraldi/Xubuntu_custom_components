#!/bin/bash

# -------------------------------------------------------
# The shell script searches for a given string in the 
# specified file. If the file is not provided, it searches
# in all the files in the folder.
# -------------------------------------------------------


# if the input arguments are zero, can do nothing
if [ $# == 0 ]; then 
	echo -e "Invalid method usage.\nType \e[3msearch_in_docs --help\e[0m for details."
	exit 1
fi

# if the input is one, check if it's the help. If so, print it
if [ $# == 1 ]; then
	if [ $1 == "-h" ] || [ $1 == "--help" ]; then 
		echo -e "search_in_docs [str] [file1] [file2] ..."
		echo -e "search_in_docs [str] [file1] [file2] ..."
	else
		echo "string given"
	fi
fi

echo "Yee"



search_in_docs_original() {
	if [ $# == 0 ] || [ $# -gt 2 ]; then 
		echo -e "Invalid method usage.\nType \e[3msearch_in_docs --help\e[0m for details."
	elif [ $# == 1 ]; then
		fgrep -Hn $1 *
	else
		fgrep -Hn $1 $2
	fi
 	# echo "$1 and $2" 
}
