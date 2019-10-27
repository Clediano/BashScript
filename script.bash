#!/bin/bash

function Pause {
    tempo=True
    while [ $tempo ]; do
        echo -ne "\nPressione ENTER para prosseguir..."
        read tempo
    done
}

function BuscarUsuario {
    userFound=`grep $1 /etc/passwd | cut -d : -f 1`
    echo $userFound
}

function CriarUsuario {
    while true;
    do
        read -p "Digite o nome do usuario('0' para cancelar):" usuarionome

        if [ $usuarionome = "0" ];
            then
                break;
            else
                userFound=`BuscarUsuario "$usuarionome"`

                if [ "$userFound" = "$usuarionome" ];
                    then
                        echo "> Nome de usuário já está em uso, escolha outro <"  
                    else
                        sudo useradd $usuarionome
                        echo "Usuario $usuarionome criado"
                        break;
                fi
        fi
    done
    return;
}

function AlterarSenha {
    read -p "Digite o nome do usuario:" usuarionome
    sudo passwd $usuarionome
    Pause
}

function RemoverUsuario {
    read -p "Digite o nome do usuario:" usuarionome

    read -p "Remover diretórios do usuário $usuarionome (S/N)? " -n 1 -r
    echo
    case "$REPLY" in 
        s|S ) sudo userdel -r $usuarionome ;;
        n|N ) sudo userdel $usuarionome ;;
        * ) echo "Entrada inválida. Nenhum usuário removido." ;;
    esac
    Pause
}

function DetalharUsuario {
    read -p "Digite o nome do usuario:" usuarionome
    id $usuarionome
    Pause
}

function AlterarUsuario {
    clear
    read -p "Digite o nome do usuario:" usuarionome
    id $usuarionome

    echo ------------------------------------
    echo "1 - Alterar diretorio do usuário"
    echo "2 - Definir data de expiracao para o usuario"
    echo "3 - Alterar nome de login do usuario"
    echo "4 - Altera o GID do grupo principal do usuário"
    echo "5 - Sair"
    echo -----------------------------------
    read resp
    case $resp in
    1)
        read -p "Digite o nome do novo diretorio:" diretorio
        sudo usermod -d /$diretorio -m $usuarionome
        echo "Diretorio alterado!"
        Pause
    ;;
    2)
        read -p "Digite a data de expiração(aaaa-mm-dd):" data
        sudo usermod -e $data $usuarionome
        echo "Data de expiração adicionada!"
        Pause
    ;;
    3)
        read -p "Digite o novo nome de login:" nome
        sudo usermod -l $nome $usuarionome
        echo "Nome de login alterado!"
        Pause
    ;;
    4)
        read -p "Digite o novo GID:" gid
        sudo usermod -g $gid $usuarionome
        echo "GID alterado!"
        Pause
    ;;    
    *) echo "Opção Inválida!";;
    esac
}



resp=0
while [ $resp -ne 6 ]
do
clear
echo ------------------------------------
echo "1 - Criar conta de usuário"
echo "2 - Alterar senha do usuário"
echo "3 - Remover usuário"
echo "4 - Ver dados da conta do usuário"
echo "5 - Alterar dados do usuário"
echo "6 - Sair"
echo -----------------------------------
echo "Escolha uma opcao"
read resp
    case $resp in
    1) CriarUsuario ;;
    2) AlterarSenha ;;
    3) RemoverUsuario ;;
    4) DetalharUsuario ;;
    5) AlterarUsuario ;;
    6) exit ;;
    *)
        echo "Opção Inválida!"
        Pause
    ;;
    esac
done
