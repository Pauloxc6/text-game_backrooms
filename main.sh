#!/usr/bin/env bash
#-----------------------------
# Imports
#-----------------------------

source ./src/libs/func.sh
source ./src/libs/entidades.sh
source ./src/libs/itens.sh

source ./src/db/player.conf

#------------------------------------
# Banner
#------------------------------------

figlet Backrooms

#----------------------------
# Var
#----------------------------

# desabilita o unicode
export LC_ALL=C
export LANG=C

export historia_base_primeira="off"

#----------------------------
# Testes Basicos
#----------------------------

if [[ -z "$player_name" ]];then
    _register
else
    _login
fi

#----------------------------
# Main
#----------------------------

echo -e "${cor_game}"
figlet Backrooms

[[ "$historia_base_primeira" = "off" ]] && { historia_base ;}

while :;do

    read -p "(nivel:thehub)# " opt
    case "$opt" in

        # Basico
        help)
            help
        ;;

        exit)
            exit 0
        ;;

        clear|cls)
            clear
            figlet Backrooms
            [[ "$historia_base_primeira" = "off" ]] && { historia_base ;}
        ;;

        status|ss)
            status
        ;;

        inventario|inv|i)
            _inventario
        ;;

        noclipping|noclip|nc)
            _noclipping
        ;;

        scan)
             echo "[!] Você não pode usar o scan aqui! [!]"
        ;;

        usar)
             echo "[!] Vocẽ não pode usar nenhum item aqui! [!]"
        ;;

        *)
            echo "[!] Error! Comando não encontrado, utilize o comando help para visualizar o menu de ajuda! [!]"
    esac
done

echo "${nul}"
