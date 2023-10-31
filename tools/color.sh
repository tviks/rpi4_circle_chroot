#!/bin/bash

declare -A c
c["RED"]='31'
c["GREEN"]='32'
c["YELLOW"]='33'
c["BLACK"]='0'

colorText () {
    printf '\e[%sm%s\e[0m\n' "${c[$1]}" "$2"
}

display_center(){
    columns="$(tput cols)"
    #printf "%*s\n" $[columns/2] "$2" 
    space=$(printf "%*s" $[columns/2])
    printf '\e[%sm%s%s\e[0m\n' "${c[$1]}" "$space" "$2"
}

output_log(){
    columns2="$(tput cols)"
    noise=$(printf '%*s' $[columns2])
    printf '%s\n' "$noise" | tr " " "#"
    echo " "
    display_center "$1" "$2"
    echo " "
    printf '%s\n' "$noise" | tr " " "#" 
}
