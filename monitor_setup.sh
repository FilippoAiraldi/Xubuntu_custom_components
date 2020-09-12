#!/bin/bash

# -----------------------------------------------------------------------------
# This script is able to detect the number of monitors and then load the 
# corresponding xfce panels configuration, based on that number. 
#
# In order to automatically execute the script when a monitor is connected to 
# the laptop:
# 1) copy this script as /usr/local/bin/monitor_hotplug.sh
# 2) make /usr/local/bin/monitor_hotplug.sh into an executable
#    sudo chmod +x /usr/local/bin/monitor_hotplug.sh
# 3) create a new udev rule as /etc/udev/rules.d/80-local.rules, with the 
#    following content:
#    SUBSYSTEM=="drm", ACTION=="change", RUN+="/usr/local/bin/monitor_hotplug.sh"
# 4) reboot the system
#
# Useful commands:
#	udevadm monitor -p
#	xrandr
#	ll /sys/class/drm/*/status
#
# Usage: 
# monitor setup (null|1|2)
#	Set ups the monitor according to the specified number of monitors.
#	If no number is given, the script autodetects the number of displays
#	and loads the corresponding panel profile.
# -----------------------------------------------------------------------------



# define constants
PROFILES="/home/filippo/.custom-components/panel_conf"
PURPLE='\033[1;35m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# define variables
conf_to_load=



# if an argument is supplied, either 1 or 2, the setup is forced to the supplied
# number of monitors. If an argument is not supplied, the script autodetects the
# number of monitors.
if [[ $# == 0 ]]; then
	# detect how many displays are available
	N_MONITORS="$(xrandr | grep -c " connected ")"
	echo -e "Detected ${PURPLE}$N_MONITORS${NC} monitor(s)"
	
	# load panels configurations based on the number of monitors
	conf_to_load=$N_MONITORS

else
	# check if argument supplied is either 1 or 2
	if [[ $1 != 1 ]] && [[ $1 != 2 ]]; then
		echo -e "${RED}Invalid number of monitors${NC}"
		exit 1
	fi
	conf_to_load=$1
fi

# eventually load the monitor setup up
if [[ "$conf_to_load" == 1 ]]; then
	echo -e "Loading ${PURPLE}$PROFILES/singlemonitor.tar.bz2${NC}"
	xfce4-panel-profiles load $PROFILES/singlemonitor.tar.bz2
else
	echo -e "Loading ${PURPLE}$PROFILES/dualmonitor.tar.bz2${NC}"
	xfce4-panel-profiles load $PROFILES/dualmonitor.tar.bz2
fi

