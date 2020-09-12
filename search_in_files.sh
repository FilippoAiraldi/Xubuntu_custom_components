#!/bin/bash

# -------------------------------------------------------
# The shell script searches for a given string in the 
# specified files. If no file is not provided, it searches
# in all the files in the folder.
# Search can be case sensitve or insensitive (-i)
#
# Usage:
#	search_in_files (-i)
# ------------------------------------------------------- 		fgrep -HnIi usage * 

# define variables
case_insensitive=false
min_number_params=1

# get options (only -i for now)
while getopts "i" opt # get options for -i (writing 'i:' would mean the option has an argument) (i:a: to specify multiple options)
do
    case $opt in
	i) case_insensitive=true
	   ((min_number_params++)) # why incrementing syntax is darn complex...
	   ;;
    esac
done

# if the input arguments are not enough, can do nothing
if [[ $# -lt $min_number_params ]]; then 
 	echo -e "Invalid method usage. Look in the function file for help"
 	exit 1
fi

# get pattern from input argument just after optional -i
pattern=${!min_number_params}

# if no file path after pattern is specified, check in all files in current folder
files="*.*"
if [[ $# -ne $min_number_params ]]; then
	files=${@:$min_number_params+1}
fi

# actual search
if [[ $case_insensitive == false ]]; then
	fgrep -Hn --color=always $pattern $files
else
	fgrep -Hni --color=always $pattern $files
fi
exit 1
