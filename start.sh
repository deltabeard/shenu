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

# If the script is not run as root, some options may not be displayed.
if [ "$UID" -ne "$ROOT_UID"  ]
then
    echo "Some options require the script be run as root."
    IS_ROOT=1
fi 

key="no value yet"  # Last key pressed
KEY_ENGLISH="Nothing" # Last key pressed in English
while true; do
    clear

 # Convert the separate home-key to home-key_num_7:
 if [ "$key" = $'\x1b\x4f\x48' ]; then
    key=$'\x1b\x5b\x31\x7e'
    #   Quoted string-expansion construct. 
 fi

 # Convert the separate end-key to end-key_num_1.
 if [ "$key" = $'\x1b\x4f\x46' ]; then
    key=$'\x1b\x5b\x34\x7e'
 fi

 case "$key" in
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
     KEY_ENGLISH="echo Page_Up"
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
    d)
     date
    ;;
    q)
    echo Time to quit...
    echo
    exit 0
    ;;
    *)
     KEY_ENGLISH="$key"
    ;;
 esac

 echo "================ MAIN MENU ================"
 echo
 if [ $MENU_ITEM -eq 0 ]; then echo -ne "\e[43m"; fi
 echo "                 Retroarch                 "
 if [ $MENU_ITEM -eq 0 ]; then echo -ne "\e[40m"; fi
 if [ $MENU_ITEM -eq 1 ]; then echo -ne "\e[43m"; fi
 echo "                Media Player               "
 if [ $MENU_ITEM -eq 1 ]; then echo -ne "\e[40m"; fi
 if [ $MENU_ITEM -eq 2 ]; then echo -ne "\e[43m"; fi
 echo "                  Settings                 "
 if [ $MENU_ITEM -eq 2 ]; then echo -ne "\e[40m"; fi
 if [ $MENU_ITEM -eq 3 ]; then echo -ne "\e[43m"; fi
 echo "                  Shutdown                 "
 if [ $MENU_ITEM -eq 3 ]; then echo -ne "\e[40m"; fi
 echo
 echo
 echo
 echo "Menu item: ${MENU_ITEM}"
 echo "==========================================="
 echo "You pressed: ${KEY_ENGLISH}"

 unset K1 K2 K3
 read -s -N1 -p "Press a key: "
 K1="$REPLY"
 read -s -N2 -t 0.001
 K2="$REPLY"
 read -s -N1 -t 0.001
 K3="$REPLY"
 key="$K1$K2$K3"

done

exit $?

