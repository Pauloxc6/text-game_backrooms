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

    read -p "# " opt
    case "$opt" in

        # Basico
        help)
            help
        ;;

        exit)
            exit 0
        ;;

        status)
            status
        ;;

        inventario)
            _inventario
        ;;

        scan)
            scan_itens
        ;;

        usar)
            _usar_item
        ;;

        noclipping)
            _noclipping
        ;;

        *)
            echo "Error! Comando não encontrado, utilize o comando help para visualizar o menu de ajuda"
    esac
done

echo "${nul}"
