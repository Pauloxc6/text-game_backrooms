#!/bin/bash
#-----------------------------
# Imports
#-----------------------------

source ./src/libs/func.sh
source ./src/libs/entidades.sh
source ./src/libs/itens.sh

# Função para exibir a descrição do nível 0
function show_level_description() {
    echo ""
    echo -e "Você caiu no nível 1 das Backrooms.\nSeu objetivo é sair daqui!\nBoa sorte!\n"
    echo -e "Descrição:"
    echo -e "\nDificuldade de Sobrevivência: Classe 1\nSeguro.\nProtegido.\nContagem Mínima de Entidades.\n"
    echo -e "O nível 1 é um armazém grande e amplo que apresenta pisos e paredes de concreto, vergalhão exposto e uma neblina baixa sem fonte discernível. O nevoeiro costuma se unir à condensação, formando poças no chão em áreas inconsistentes. Ao contrário do nível 0, esse nível possui um suprimento consistente de água e eletricidade, o que permite a habitação indefinida por andarilhos, desde que as precauções apropriadas sejam tomadas. Também é muito mais expansivo, possuindo escadas, elevadores, salas isoladas e corredores.\n"
    echo -e "Caixas de suprimentos aparecem e desaparecem aleatoriamente dentro do nível, geralmente contendo uma mistura de itens vitais (alimentos, água de amêndoa, baterias, lonas, armas 1 , roupas, suprimentos médicos) e objetos absurdos (peças variadas de carros, caixas de giz de cera, seringas usadas, papel parcialmente queimado, ratos vivos, ratos em um estado catatônico que foram injetados com substâncias desconhecidas, cadarços, alterações soltas, pacotes de cabelos humanos ). As caixas devem ser abordadas com cautela devido ao seu conteúdo, mas são um recurso valioso. \n"
    echo -e "Além disso, pinturas e desenhos grosseiros, sem origem ou significado aparente, aparecem nas paredes e pisos. Eles são conhecidos por mudar de aparência e desaparecer quando não estão em uma linha de visão direta ou quando apagados. As luminárias no nível 1 são propensas a piscar e falhar em intervalos inconsistentes; Quando isso ocorre, os suprimentos podem desaparecer inexplicavelmente e entidades hostis podem parecer inesperadamente. Essas entidades raramente atacam em grupos e tendem a evitar luzes e grandes reuniões de pessoas. É aconselhável carregar uma fonte de luz confiável e dormir com os itens que você não deseja perder.\n"
}

# Função para tentar fazer noclip
function try_noclip() {
    local chance=$((1 + RANDOM % 10))  # 10% de chance de sucesso
    if [[ "$chance" -eq 2 ]]; then
        echo -e "\n[+] Você conseguiu fazer noclip em uma pintura e foi para o nível fun! [+]"
        update_player_data "nivel" "22"
        player_room=$(get_player_data "nivel")
        bash "./src/rooms/room${player_room}/room${player_room}.sh"
    else
        echo -e "\n[!] Você tentou fazer noclip, mas não teve sucesso. Tente novamente! [!]"
    fi
}

# Função para gerar eventos aleatórios ao se mover
function generate_random_event() {
    local random=$((1 + RANDOM % 10))
    case "$random" in
        4)
            echo -e "\n[+] Você encontrou uma porta! [+]"
            echo -e "[-] Após vasculhar atás da porta, você encontrou uma saida para o nível 2!\nDeseja ir para o próximo nível? [s/n]"
            read -p "> " opt_sn
            if [[ "${opt_sn,,}" = "s" ]]; then
                echo -e "\n[-] Você passou pela porta!"
                update_player_data "nivel" "2"
                player_room=$(get_player_data "nivel")
                bash "./src/rooms/room${player_room}/room${player_room}.sh"
            else
                echo -e "\n[!] Você permaneceu dentro do níve 1! [!]"
            fi
        ;;

        *)
            echo "[+] Você continua andando, mas não encontra nada de interessante. [+]"
        ;;
    esac
}

# Função principal do nível 1
function main() {
    # Atualiza o nível do jogador para 0
    update_player_data "nivel" "1"

    # Exibe a descrição do nível 0
    show_level_description

    # Loop principal do nível 0
    while :; do
        echo ""
        read -p "(nivel:1)# " opt_m

        # Verifica a sanidade do jogador antes de cada ação
        check_sanity

        case "${opt_m,,}" in
            frente|fr)
                echo "[-] Você andou para frente..."
                sleep 2
                generate_random_event
            ;;

            esquerda|es)
                echo "[-] Você virou à esquerda..."
                sleep 2
                generate_random_event
            ;;

            direita|di)
                echo "[-] Você virou à direita..."
                sleep 2
                generate_random_event
            ;;

            atras|at)
                echo "[-] Você andou para trás..."
                sleep 2
                generate_random_event
            ;;

            noclipping|noclip|nc)
                try_noclip
            ;;

            status|ss)
                status
            ;;

            inventario|inv|i)
                _inventario
            ;;

            scan)
                scan_itens
            ;;

            usar)
                _usar_item
            ;;

            drop)
                _remover_item "$1"
            ;;

            exit)
                exit 0
            ;;

            clear|cls)
                clear
                figlet Backrooms
                show_level_description
            ;;

            *)
                help
            ;;
        esac
    done
}

# Inicia o nível 1
main