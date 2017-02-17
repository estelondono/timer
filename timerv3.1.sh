#!/bin/bash

# VERSIÓN 3.1

# Countdown timer with the help from
# http://superuser.com/questions/611538/is-there-a-way-to-display-a-countdown-or-stopwatch-timer-in-a-terminal
# https://linuxconfig.org/bash-scripting-tutorial
# Help with "case ... esac" from
# http://askubuntu.com/questions/1705/how-can-i-create-a-select-menu-in-a-shell-script
# Help with the arrays from
# http://tldp.org/LDP/Bash-Beginners-Guide/html/sect_10_03.html

# Clear the screen to show all the scripts
clear;

# Catch when the user press "Ctrl + C"
trap bashtrap INT
echo $INT
# Print a message if the user press "Ctrl + C"
bashtrap()
{
    echo -e "\n\n\033[1;31mEnding countdown by user.\n"
    exit
}

# The "help" text
function help {
    echo -e '\nThe first parameter has to be:'
    echo 'An integer for the countdown'
    echo -e 'or "p" to select an option.\n'
}

# Function to start the countdown and play the sound
function timer {
        time=$((`date +%s` + $1*60)); # If you want to use seconds erase "*60" from this line
        while [ "$time" -ge `date +%s` ]; do 
            echo -ne "\033[1;34m$(date -u --date @$(($time - `date +%s` )) +%H:%M:%S)\r";
            sleep 0.1
        done
    # Print the hour when the alarm goes on
    echo -e "\n\033[0mAlarm: \033[1;31m`date`\033[0m\n"
    # Plays the sound for the alarm
    # Use the complete path to the file to call the script from every place
    mplayer ~/Documentos/Scripts/alarma.mp3
}

# Analise the first parameter that enters the script

# If the parameter is an integer, call just one countdown-timer
if [[ "$1" =~ ^-?[0-9]+$ ]];
    then
        timer $1

# If the parameter is "p" print a selection for the user
elif [ $1 = p ]; then
    echo -e "***TIPOS DE AMASADO*** \n"
    PS3="Select an option: "
    OPTIONS=("Amasado Tradicional" "Amasado Mejorado" "Amasado Intensivo" "Salir")
    select opt in "${OPTIONS[@]}"
    do
        case $REPLY in
            1)  timer 5 # Just call a timer for 5 minutes
                break
                ;;
            2)  timer 5 # 5 minutes countdown
                timer 5 # and another 5 minutes countdown
                break
                ;;
            3)  timer 5 # 5 minutes countdown
                timer 8 # and another 8 minutes countdown
                break
                ;;
            4)  echo -e "\nExiting the countdown\n"
                break
                ;;
            *)  echo -e "\033[1;31mInvalid selection\033[0m"
                # Print the diferent options from $OPTIONS
                i="0"
                t=${#OPTIONS[*]}
                echo -e "\n***KNEAD TYPES*** \nChoose the kneading type you need:\n"
                while [ $i -lt "$t" ]; do
                    let i=i+1
                    echo "$i) ${OPTIONS[(($i-1))]}"
                done
                ;;
        esac
    done

# If the first parameter isn't an integer or "p", print the help and exit.
else
    help
fi

# Exit the script
exit
