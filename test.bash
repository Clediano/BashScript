#!/bin/bash

function InicialNumerica {
    numerica=`$1 | sed "^[0-9]"`
    echo $numerica
}

read -p "informe o usuário: " usuario

valor=`InicialNumerica "$usuario"`
echo $valor