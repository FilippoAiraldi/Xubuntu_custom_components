#!/bin/bash

# connects to Ferrari rdp session.
# press ctrl + alt + enter to exit the fullscreen mode.

# constants
USERNAME="fairaldi"
RDP_PATH="/home/filippo/Documents/Ferrari/Ferrari.rdp"

# check if rdp file exists
if [ ! -f "$RDP_PATH" ]; then

	echo "$RDP_PATH does not exist."
	return

fi

echo "Connecting to remote desktop..."
echo "Username: $USERNAME"

# ask for password
echo -n "Password: "
read -s password

# run xfreerdp command
xfreerdp $RDP_PATH /u:$USERNAME /p:$password

