#!/bin/bash

# connects to Ferrari rdp session.
# press ctrl + alt + enter to exit the fullscreen mode.

# rdp location
RDP_PATH="/home/filippo/Documents/Ferrari/Ferrari.rdp"

# check if rdp file exists
if [ ! -f "$RDP_PATH" ]; then

	echo "$RDP_PATH does not exist."
	return

fi

echo "Connecting to remote desktop..."

# ask for password
echo -n "Username: "
read username

# ask for password
# echo -n "Password: "
# read -s password
ask() {
    charcount='0'
    prompt="Password: "
    reply=''
    while IFS='' read -n '1' -p "${prompt}" -r -s 'char'
    do
        case "${char}" in
            # Handles NULL
            ( $'\000' )
            break
            ;;
            # Handles BACKSPACE and DELETE
            ( $'\010' | $'\177' )
            if (( charcount > 0 )); then
                prompt=$'\b \b'
                reply="${reply%?}"
                (( charcount-- ))
            else
                prompt=''
            fi
            ;;
            ( * )
            prompt='*'
            reply+="${char}"
            (( charcount++ ))
            ;;
        esac
    done
    printf '\n' >&2
    printf '%s\n' "${reply}"
}

password="$(ask)"

# run xfreerdp command
xfreerdp $RDP_PATH +clipboard +toggle-fullscreen /rfx /multimon /smart-sizing /u:$username /p:$password

