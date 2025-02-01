function _inventario(){

    echo ""

    echo "[+] Inventario [+]"

    for slot in {1..3}; do
         local player_slot="$(grep "^slot${slot}=" "$PWD/src/db/player.conf" | cut -d'=' -f2 | tr -d '"')"
        echo "[^] Slot ${slot}: ${player_slot}"
    done
}

function scan_itens(){

    local player_slot1="$(grep "^slot1=" "$PWD/src/db/player.conf" | cut -d'=' -f2 | tr -d '"')"
    local player_slot2="$(grep "^slot2=" "$PWD/src/db/player.conf" | cut -d'=' -f2 | tr -d '"')"
    local player_slot3="$(grep "^slot3=" "$PWD/src/db/player.conf" | cut -d'=' -f2 | tr -d '"')"

    local random="$((1 + $RANDOM % 10))"

    echo "[+] Analisando o ambiente [+]"
    sleep 5s

    if [[ "$random" -eq "1" ]];then

        echo "[+] Você encontrou uma lanterna [+]"
        read -p "[-] Deseja adicionar ao seu inventário [s/n]? " item_sn

        if [[ "${item_sn,,}" = "s" ]];then
            if [ -z "$player_slot1" ]; then
                echo "[+] Adicionando a lanterna ao slot 1 [+]"
                sed -i "s/^slot1=.*/slot1=\"lanterna\"/" "$PWD/src/db/player.conf"

            elif [ -z "$player_slot2" ]; then
                echo "[+] Adicionando a lanterna ao slot 2 [+]"
                sed -i "s/^slot2=.*/slot2=\"lanterna\"/" "$PWD/src/db/player.conf"

            elif [ -z "$player_slot3" ]; then
                echo "[+] Adicionando a lanterna ao slot 3 [+]"
                sed -i "s/^slot3=.*/slot3=\"lanterna\"/" "$PWD/src/db/player.conf"

            else
                echo "[!] Todos slots estão cheios! [!]"
            fi
        else
            echo "[!] A lanterna não foi adionada ao inventário! [!]"
        fi

    elif [[ "$random" -eq "5" ]];then
        echo "[+] Você encontrou uma agua de amendoas [+]"
        read -p "[-] Deseja adicionar ao seu inventário [s/n]? " item_sn

        if [[ "${item_sn,,}" = "s" ]];then
            if [ -z "$player_slot1" ]; then
                echo "[+] Adicionando a agua de amendoas ao slot 1[+] "
                sed -i "s/^slot1=.*/slot1=\"agua_de_amendoas\"/" "$PWD/src/db/player.conf"

            elif [ -z "$player_slot2" ]; then
                echo "[+] Adicionando a agua de amendoas ao slot 2 [+]"
                sed -i "s/^slot2=.*/slot2=\"agua_de_amendoas\"/" "$PWD/src/db/player.conf"

            elif [ -z "$player_slot3" ]; then
                echo "[+] Adicionando a agua de amendoas ao slot 3 [+]"
                sed -i "s/^slot3=.*/slot3=\"agua_de_amendoas\"/" "$PWD/src/db/player.conf"

            else
                echo "[!] Todos slots estão cheios! [!]"
            fi
        else
            echo "[!] A agua de amendoas não foi adionada ao inventário! [!]"
        fi
    else
        echo "[!] Nenhum item encontrado! [!]"
    fi
}

function _remover_item() {
    local item=$1  # Item a ser removido

    # Verifica em qual slot o item está armazenado
    for slot in {1..3}; do
        local slot_item=$(grep "^slot$slot=" "$PWD/src/db/player.conf" | cut -d'=' -f2 | tr -d '"')
        if [[ "$slot_item" == "$item" ]]; then
            # Remove o item do slot (deixa o slot vazio)
            sed -i "s/^slot$slot=.*/slot$slot=\"\"/" "$PWD/src/db/player.conf"
            echo "[-] Item '$item' removido do slot$slot. [-]"
            return 0
        fi
    done

    echo " [!] Item '$item' não encontrado no inventário. [!]"
}

function _usar_item() {
    echo ""
    echo "[+] Escolha um item para usar [+]"
    
    # Exibe os itens do inventário
    for slot in {1..3}; do
        local slot_item=$(grep "^slot$slot=" "$PWD/src/db/player.conf" | cut -d'=' -f2 | tr -d '"')
        echo "[^] Slot$slot: $slot_item"
    done
    
    read -p "[-] Digite o nome do item: " item_escolhido

    # Verifica se o item existe no inventário
    for slot in {1..3}; do
        local slot_item=$(grep "^slot$slot=" "$PWD/src/db/player.conf" | cut -d'=' -f2 | tr -d '"')
        if [[ "$slot_item" == "$item_escolhido" ]]; then
            echo -e "\n[-] Você usou o item '$item_escolhido'."

            # Lógica específica para cada item
            case "$item_escolhido" in
                "agua_de_amendoas")
                    echo "[+] Você bebeu a água de amêndoas e se sente revigorado! [+]"
                    echo "[+] Você teve um aumento de 1000 de sanidade [+]"
                    sed -i "s/^sanidade=.*/sanidade=\"1000\"/" "$PWD/src/db/player.conf"
                    _remover_item "agua_de_amendoas"
                ;;

                "lanterna")
                    echo "[+] Você acendeu a lanterna. Agora você pode ver melhor! [+]"
                ;;

                *)
                    echo "[!] Você usou o item '$item_escolhido', mas nada aconteceu. [!]"
                ;;
            esac
            return 0
        fi
    done

    echo "[!] Item '$item_escolhido' não encontrado no inventário. [!]"
}