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
# -----------------------------------------------------------------------------

# wait for system to load monitor
# sleep 3

# define constants
PROFILES="/home/filippo/.custom-components/panel_conf"

# detect how many displays are available
N_MONITORS="$(xrandr | grep -c " connected ")"

# load panels configurations based on the number of monitors
if [[ "$N_MONITORS" == 1 ]]; then
	xfce4-panel-profiles load $PROFILES/singlemonitor.tar.bz2
else
	xfce4-panel-profiles load $PROFILES/dualmonitor.tar.bz2
fi

