#!/bin/bash
#
# Copyright (C) 2015   Mahyar Koshkouei
# This program is licensed under GPLv2. Please see LICENSE for
# more information.
#
# https://github.com/deltabeard/shenu
#
#
#
IS_ROOT=0       # 0 if program run as root.
ROOT_UID=0      # Only users with $UID 0 have root privileges.
HOME_DIR=${HOME} # The starting directory is the users home directory.
MENU_ITEM=0     # The currently selected menu item
KEY="no value yet"  # Last key pressed
KEY_ENGLISH="Nothing" # Last key pressed in English
ACCESS="FALSE"  # If a menu should be accessed
COLUMNS=50      # Can't get number of columns without tput, so setting it here.

# If the script is not run as root, some options may not be displayed.
if [ "$UID" -ne "$ROOT_UID"  ]
then
    echo "Some options require the script be run as root."
    IS_ROOT=1
fi 

keyinput ()
{
 unset K1 K2 K3
 read -s -N1 -p "Press a key: "
 K1="$REPLY"
 read -s -N2 -t 0.001
 K2="$REPLY"
 read -s -N1 -t 0.001
 K3="$REPLY"
 KEY="$K1$K2$K3"

 # Convert the separate home-key to home-key_num_7:
 if [ "$KEY" = $'\x1b\x4f\x48' ]; then
    KEY=$'\x1b\x5b\x31\x7e'
    #   Quoted string-expansion construct. 
 fi

 # Convert the separate end-key to end-key_num_1.
 if [ "$KEY" = $'\x1b\x4f\x46' ]; then
    KEY=$'\x1b\x5b\x34\x7e'
 fi

 case "$KEY" in
    $'\x1b\x5b\x32\x7e')  # Insert
     KEY_ENGLISH="Insert Key"
    ;;
    $'\x1b\x5b\x33\x7e')  # Delete
     KEY_ENGLISH="Delete Key"
    ;;
    $'\x1b\x5b\x31\x7e')  # Home_key_num_7
     KEY_ENGLISH="Home Key"
    ;;
    $'\x1b\x5b\x34\x7e')  # End_key_num_1
     KEY_ENGLISH="End Key"
    ;;
    $'\x1b\x5b\x35\x7e')  # Page_Up
     KEY_ENGLISH="Page_Up"
    ;;
    $'\x1b\x5b\x36\x7e')  # Page_Down
     KEY_ENGLISH="Page_Down"
    ;;
    $'\x1b\x5b\x41')  # Up_arrow
     let "MENU_ITEM -= 1"
     KEY_ENGLISH="Up arrow"
    ;;
    $'\x1b\x5b\x42')  # Down_arrow
     let "MENU_ITEM += 1"
     KEY_ENGLISH="Down arrow"
    ;;
    $'\x1b\x5b\x43')  # Right_arrow
     KEY_ENGLISH="Right arrow"
    ;;
    $'\x1b\x5b\x44')  # Left_arrow
     KEY_ENGLISH="Left arrow"
    ;;
    $'\x09')  # Tab
     KEY_ENGLISH="Tab Key"
    ;;
    $'\x0a')  # Enter
     KEY_ENGLISH="Enter Key"
    ;;
    $'\x1b')  # Escape
     KEY_ENGLISH="Escape Key"
    ;;
    $'\x20')  # Space
     KEY_ENGLISH="Space Key"
    ;;
    x)
     # Access option
     ACCESS="TRUE"
    ;;
    d)
     date
    ;;
    q)
    echo Time to quit...
    echo
    exit 0
    ;;
    *)
     KEY_ENGLISH="$KEY"
     ;;
 esac

}

output ()
{
    REPEAT=$COLUMNS
    let REPEAT/=2
    let REPEAT-=$TEXT_LENGTH  # Half the length of the text

    for i in `seq 1 $REPEAT`;
    do
        echo -n "$TEXT_TO_REPEAT"
    done
}

# Main program

while true; do
 clear
 # Stops the Menu from exceeding limits
 case $MENU_ITEM in
     -1)
         MENU_ITEM=0
         ;;
     4)
         MENU_ITEM=3 # Last item in the Menu
         ;;
 esac

 TEXT_LENGTH=5; TEXT_TO_REPEAT="="; output;
 echo -n " MAIN MENU "
 TEXT_LENGTH=6; TEXT_TO_REPEAT="="; output;
 echo; echo;

 if [ $MENU_ITEM -eq 0 ]; then echo -ne "\e[43m"; fi
 TEXT_LENGTH=6; TEXT_TO_REPEAT=" "; output;
 echo -n "  Retroarch "
 TEXT_TO_REPEAT=" "; output; echo;
 if [ $MENU_ITEM -eq 0 ]; then echo -ne "\e[40m"; fi

 if [ $MENU_ITEM -eq 1 ]; then echo -ne "\e[43m"; fi
 TEXT_LENGTH=7; TEXT_TO_REPEAT=" "; output;
 echo -n " Media Player "
 TEXT_TO_REPEAT=" "; output; echo;
 if [ $MENU_ITEM -eq 1 ]; then echo -ne "\e[40m"; fi

 if [ $MENU_ITEM -eq 2 ]; then echo -ne "\e[43m"; fi
 TEXT_LENGTH=5; TEXT_TO_REPEAT=" "; output;
 echo -n " Settings "
 TEXT_TO_REPEAT=" "; output; echo;
 if [ $MENU_ITEM -eq 2 ]; then echo -ne "\e[40m"; fi

 if [ $MENU_ITEM -eq 3 ]; then echo -ne "\e[43m"; fi
 TEXT_LENGTH=5; TEXT_TO_REPEAT=" "; output;
 echo -n " Shutdown "
 TEXT_TO_REPEAT=" "; output; echo;
 if [ $MENU_ITEM -eq 3 ]; then echo -ne "\e[40m"; fi
 echo
 echo
 echo
 echo "Menu item: ${MENU_ITEM}"
 TEXT_LENGTH=0; TEXT_TO_REPEAT="="; output; output; echo;
 echo "You pressed: ${KEY_ENGLISH}"

 keyinput  # Get input from the keyinput function
 if [ $ACCESS == "TRUE" ]
 then
     case $MENU_ITEM in
         0)
             # Start Retroarch
             clear
             echo "Starting Retroarch"
             retroarch &> /dev/null
             ;;
         1)
             # Go to file picker for media files
            ;;
         2)
             # Go to Settings
             ;;
         3)
             # Shutdown
             # poweroff
             ;;
         *)
             echo "Unknown command."
             read -p "Press any key to continue."
             ;;
     esac
 fi
 ACCESS="FALSE" # Resetting the ACCESS variable so that the menu does
                # not select an item on its own.
done



exit $?

