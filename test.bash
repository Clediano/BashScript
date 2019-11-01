#!/bin/bash
function ValidaNomeUsuario {

    nome_REGEX="^[a-zA-Z]{1}"
    name_to_check=$1

    if [[ "${name_to_check}" =~ ${nome_REGEX} ]]; then
        echo "0"
    else
        echo "1"
    fi
}

read -p "Digite o nome do usuario:" usuarionome

isValid=`ValidaNomeUsuario "$usuarionome"`

 #echo $isValid