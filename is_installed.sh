#!/bin/bash

# ----------------------------------------------------
# A shell script that prints if a package is installed
# ----------------------------------------------------

apt list --installed | grep --color=always "$1" 
