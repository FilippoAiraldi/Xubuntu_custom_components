#!/bin/bash
# -------------------------------------------------------
# A shell script that fixes screen tearing on intel video 
# cards and switches between nvidia and intel graphic cards.
# Written by: Bruno Assis
# Created on: 25/03/2017
# -------------------------------------------------------



#asks for sudo if the user uid != 0 then calls the script again with the current user name
(( EUID != 0 )) && exec sudo -- "$0" "$@$USER"



#-----------------
#----Settings-----
#-----------------
PREVIOUS_USER=$1
SCRIPT_NAME="20-intel.conf"
CONF_BASE_PATH="/etc/X11/"
CONF_BASE_DIR="xorg.conf.d"
CONF_PATH="/etc/X11/$CONF_BASE_DIR/"		# /etc/X11/xorg.conf.d/
CONF_FILE_PATH="$CONF_PATH$SCRIPT_NAME"		# /etc/X11/xorg.conf.d/20-intel.conf
CURRENT_VIDEO_CARD=""

PURPLE='\033[1;35m'
BLUE='\033[3;34m'
NC='\033[0m' # No Color


#-----------------
#----Functions----
#-----------------
#creates the config file.
function CreateTearingFreeFile {
	echo 'Section "Device"' >> $1
	echo '   Identifier  "Intel Graphics"' >> $1
	echo '   Driver      "intel"' >> $1
	echo '   Option      "TearFree"    "true"' >> $1
	echo "EndSection" >> $1
}

#switches the environment to use nvidia graphics card
function SwitchToNvdia {
	rm $CONF_FILE_PATH
	printf $BLUE
	prime-select nvidia
	printf '\033[0m'
}

#switches the environment to use intel's graphics card
function SwitchToIntel {
	cd $CONF_PATH
	CreateTearingFreeFile $SCRIPT_NAME
	printf $BLUE
	prime-select intel
	printf '\033[0m'
}

function LogoutFromCurrentSession {
	echo -e -n "Logout to apply changes. Logout now? [Y|n] "
	read option
	initial="$(echo $option | head -c 1)"
	if [[ "$initial" = "y" || "$initial" = "Y" ]]; then
		#log out from the current session for the current user
		su -c "kill -9 -1" "$PREVIOUS_USER"
	fi
}

function SetupEnvironment {
	if [ ! -d "$CONF_BASE_PATH" ]; then 
		echo -e "Error: could not find $CONF_BASE_PATH."
		exit 1
	else
		if [ ! -d "$CONF_PATH" ]; then 
			echo -e "Warning: Could not find $CONF_BASE_DIR... Trying to create it."
			cd $CONF_BASE_PATH
			mkdir $CONF_BASE_DIR
			if [ ! -d "$CONF_PATH" ]; then
				echo -e "Error: could not create $CONF_BASE_DIR folder."
				exit 1
			else
				echo -e "$CONF_BASE_DIR folder created successfully."
			fi
		fi
	fi
}

function CheckForCurrentVideoCardInUse {
	local _VIDEO_CARD=`glxinfo|egrep "OpenGL vendor|OpenGL renderer*"`
	if [[ $_VIDEO_CARD == *"NVIDIA"* && $_VIDEO_CARD == *"GeForce"* ]]; then
		CURRENT_VIDEO_CARD="NVIDIA"
	elif [[ $_VIDEO_CARD == *"Intel"* ]]; then
		CURRENT_VIDEO_CARD="INTEL"
	else
		ErrorHandler
	fi
}

function ErrorHandler {
	echo -e "Could not find your video card"
	echo -e "Please use glxinfo to check if the name is correct or if you are using NVIDIA's or Intel's card"
	exit 1
}



#------------------
#--Program Flow ---
#------------------

# Setups the environment if it hasn't already been set.
CheckForCurrentVideoCardInUse
SetupEnvironment
echo -e "Current video card in use: ${PURPLE}$CURRENT_VIDEO_CARD${NC}"


# If the file exists then we should delete it and start nvidia
if [ $CURRENT_VIDEO_CARD == "INTEL" ]; then
	echo -e -n "Switch graphics card to ${PURPLE}NVIDIA${NC}? [Y|n] "
	read option
	initial="$(echo $option | head -c 1)"
 	if [[ "$initial" == "y" || "$initial" == "Y" ]]; then
 		SwitchToNvdia
 		LogoutFromCurrentSession
 	fi
elif [ $CURRENT_VIDEO_CARD == "NVIDIA" ]; then
	echo -e -n "Switch graphics card to ${PURPLE}INTEL${NC}? [Y|n] "
	read option
	initial="$(echo $option | head -c 1)"
 	if [[ "$initial" == "y" || "$initial" == "Y" ]]; then
 		SwitchToIntel
 		LogoutFromCurrentSession
 	fi
else
	ErrorHandler
fi
