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

function ValidaNomeUsuario {

    nome_REGEX="^[a-zA-Z]{1}"
    name_to_check=$1

    if [[ "${name_to_check}" =~ ${nome_REGEX} ]]; then
        echo "0"
    else
        echo "1"
    fi
}

function CriarUsuario {
    while true;
    do
        read -p "Digite o nome do usuario('0' para cancelar):" usuarionome

        if [ $usuarionome = "0" ];
            then
                break;
            else
                isValid=`ValidaNomeUsuario "$usuarionome"`
                userFound=`BuscarUsuario "$usuarionome"`
                if [ "$isValid" = "0" ];
                    then
                        if [ "$userFound" = "$usuarionome" ];
                            then
                                echo "> Nome de usuário já está em uso, escolha outro <"  
                            else
                                sudo useradd $usuarionome
                                echo "Vamos adicionar uma senha!"
                                AlterarSenha $usuarionome
                                echo "Usuário criado!"
                                Pause
                                break;
                        fi
                    else
                        echo "> Nome de usuário inválido <" 
                fi
        fi
    done
    return;
}

function AlterarSenha {
    usuarionome=""
    if [ $# -eq 0 ] ;
        then
            read -p "Digite o nome do usuario: " usuarionome
        else
            usuarionome=$1
            
    fi
    sudo passwd $usuarionome
    Pause
}

function RemoverUsuario {
    read -p "Digite o nome do usuario:" usuarionome

    userFound=`BuscarUsuario $usuarionome`

    if [ "$userFound" = "$usuarionome" ];
        then
            read -p "Tem certeza que deseja remover o usuário $usuarionome (S/N)? " 
            echo
            case "$REPLY" in 
                s|S )
                    if [ ! -d "/home/$usuarionome" ];
                        then
                            sudo userdel $usuarionome
                        else
                            sudo userdel -r $usuarionome
                    fi
                ;;
                * ) echo "Nenhum usuário removido." ;;
            esac
        else
            echo "Usuário inexistente!"
    fi
    Pause
}

function DetalharUsuario {
    read -p "Digite o nome do usuario:" usuarionome
    userFound=`BuscarUsuario "$usuarionome"`
    if [ "$userFound" = "$usuarionome" ];
        then
            sudo dpkg -l | grep finger
            if [ $? = "1" ] ;
                then
                    echo "Precisamos instalar o pacote 'finger'! "
                    Pause
                    sudo apt-get install finger
                else
                    clear
                    finger $usuarionome
                    Pause
            fi
        else
            echo "Usuário inexistente"
            Pause
    fi
    
}

function AlterarUsuario {
    clear
    read -p "Digite o nome do usuario:" usuarionome

    userFound=`BuscarUsuario "$usuarionome"`
        if [ "$userFound" = "$usuarionome" ];
            then
                selecionado=0
                while [ $selecionado -ne 5 ]
                do
                    clear
                    echo ------------------------------------
                    echo "1 - Alterar diretorio do usuário"
                    echo "2 - Definir data de expiracao para o usuario"
                    echo "3 - Alterar nome de login do usuario"
                    echo "4 - Alterar informações do usuario"
                    echo "5 - Sair"
                    echo -----------------------------------
                    read resp
                    case $resp in
                    1)
                        read -p "Digite o nome do novo diretorio:" diretorio
                        sudo usermod -d /$diretorio -m $usuarionome
                        if [ $? = "0" ] ;
                            then
                                echo "Diretorio alterado!"                        
                        fi
                        
                        Pause
                    ;;
                    2)
                        read -p "Digite a data de expiração(aaaa-mm-dd):" data
                        sudo usermod -e $data $usuarionome

                        if [ $? = "0" ] ;
                            then
                                echo "Data de expiração adicionada!"                            
                        fi
                        Pause
                    ;;
                    3)
                        read -p "Digite o novo nome de login:" nome
                        sudo usermod -l $nome $usuarionome

                        if [ $? = "0" ] ;
                            then
                                usuarionome=$nome
                                echo "Nome de login alterado!"                            
                        fi
                        Pause
                    ;;
                    4)
                        sudo chfn $usuarionome
                        if [ $? = "0" ] ;
                            then
                                echo "Informações alteradas!"                            
                        fi
                        Pause
                    ;;
                    5) break ;;
                    *)
                        echo "Opção Inválida!"
                        Pause
                    ;;
                    esac
                done
            else
                echo "> Usuário inexistente <" 
                Pause
        fi
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
