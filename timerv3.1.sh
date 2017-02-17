#!/bin/bash

# VERSIÓN 3.1

# Función timer obtenido de
# http://superuser.com/questions/611538/is-there-a-way-to-display-a-countdown-or-stopwatch-timer-in-a-terminal
# y con ayuda de 
# https://linuxconfig.org/bash-scripting-tutorial
# Y para "case" la ayuda fue de
# http://askubuntu.com/questions/1705/how-can-i-create-a-select-menu-in-a-shell-script
# Algo más de ayuda con los vectores de
# http://tldp.org/LDP/Bash-Beginners-Guide/html/sect_10_03.html

# Limpiamos la pantalla
clear;

# Detectar si el usuario pulsa Ctrl + C
trap bashtrap INT
echo $INT
# Imprime explicación y sale cuando se pulsa Ctrl + C
bashtrap()
{
    echo -e "\n\n\033[1;31mSaliendo del temporizador por orden del usuario.\n"
    exit
}

# Con esta función imprimimos en pantalla la ayuda del Script
function ayuda {
    echo -e '\nEl primer término pasado a la función debe ser:'
    echo 'Un número (entero) de minutos para el temporizador'
    echo -e 'o "p" para temporizador de ciclo de amasado de panes y escoger el tipo de amasado.\n'
}

# Función que crea el contador de tiempo y reproduce el sonido
function timer {
        time=$((`date +%s` + $1*60)); 
        while [ "$time" -ge `date +%s` ]; do 
            echo -ne "\033[1;34m$(date -u --date @$(($time - `date +%s` )) +%H:%M:%S)\r";
            sleep 0.1
        done
    # Imprime la hora en que se activó la alarma en rojo y vuelve a poner las letras sin colores
    echo -e "\n\033[0mEsta alarma se activó el: \033[1;31m`date`\033[0m\n"
    # Reproduce el sonido | Se tiene que la dirección completa
    # para que se pueda reproducir desde cualquier lugar que se corra el Script
    mplayer ~/Documentos/Scripts/alarma.mp3
}

# Revisa el primer parámetro pasado al Script

# Si el primer parámetro es un número, correr un solo temporizador
# Sólo acepta números enteros
if [[ "$1" =~ ^-?[0-9]+$ ]];
    then
        timer $1

# Si el primer parámetro es "p" realiza un primer temporizador de 5 minutos
# y luego un segundo temporizador según la selección realizada
elif [ $1 = p ]; then
    echo -e "***TIPOS DE AMASADO*** \n"
    PS3="Seleccione una de las opciones anteriores: "
    OPTIONS=("Amasado Tradicional" "Amasado Mejorado" "Amasado Intensivo" "Salir")
    select opt in "${OPTIONS[@]}"
    do
        case $REPLY in
            1)  timer 5 # Tiempo de amasado en PRIMERA velocidad
                break
                ;;
            2)  timer 5 # Tiempo de amasado en PRIMERA velocidad
                timer 5 # Tiempo de amasado en SEGUNDA velocidad
                break
                ;;
            3)  timer 5 # Tiempo de amasado en PRIMERA velocidad
                timer 8 # Tiempo de amasado en SEGUNDA velocidad
                break
                ;;
            4)  echo -e "\nSaliendo del temporizador\n"
                break
                ;;
            *)  echo -e "\033[1;31mSeleccion inválida\033[0m"
                # Imprime la lista de opciones
                i="0"
                t=${#OPTIONS[*]}
                echo -e "\n***TIPOS DE AMASADO*** \nEscoger el tipo de amasado para el temporizador\n"
                while [ $i -lt "$t" ]; do
                    let i=i+1
                    echo "$i) ${OPTIONS[(($i-1))]}"
                done
                ;;
        esac
    done

# Si el primer parámetro no es un número entero ni "p" imprime una pequeña ayuda y termina sale
else
    ayuda
fi

# Sale del Script
exit