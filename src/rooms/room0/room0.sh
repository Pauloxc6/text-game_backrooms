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
    echo -e "Você caiu no nível 0 das Backrooms.\nSeu objetivo é sair daqui!\nBoa sorte!\n"
    echo -e "Descrição:"
    echo -e "\nDificuldade de Sobrevivência: Classe 1\nSeguro.\nProtegido.\nContagem Mínima de Entidades.\n"
    echo -e "O nível 0 é um espaço não linear, semelhante às salas dos fundos de uma saída de varejo. Todas as salas no nível 0 parecem uniformes e compartilham características superficiais, como um papel de parede amarelado, tapete úmido e iluminação fluorescente colocada inconsistentemente. No entanto, não há dois quartos dentro do nível idênticos.\n"
    echo -e "A iluminação instalada pisca de forma inconsistente e zumbem em uma frequência constante. Esse zumbido é notavelmente mais alto e mais desagradável do que o zumbido fluorescente comum. A substância saturando o tapete não pode ser consistentemente identificada. Não é água, nem é seguro consumir.\n"
    echo -e "Os espaços lineares no nível 0 são alterados drasticamente; É possível caminhar em uma linha reta e retornar ao ponto de partida, e refazer suas etapas resultará em um conjunto diferente de salas que aparecem das que já foram passadas. Devido a isso e à semelhança visual entre os quartos, a navegação consistente é extremamente difícil. Dispositivos como bússolas e localizadores de GPS não funcionam no nível, e as comunicações de rádio são distorcidas e não confiáveis.\n"
    echo -e "O nível 0 é totalmente imóvel e completamente desprovido de vida. Apesar de ser a entrada principal dos Backrooms, nunca foi relatado o contato com outros andarilhos dentro do nível. Presumivelmente, um grande número de pessoas morreu antes de sair, o mais provável causa a desidratação, a fome e o trauma psicológico devido à privação e isolamento sensoriais. No entanto, não foram relatados cadáveres nessas mortes hipotéticas. A tentativa de inserir o nível 0 em um grupo resultará na separação do grupo até que o nível seja excitado.\n"
}

# Função para tentar fazer noclip
function try_noclip() {
    local chance=$((1 + RANDOM % 10))  # 10% de chance de sucesso
    if [[ "$chance" -eq 1 ]]; then
        echo -e "\n[+] Você conseguiu fazer noclip e sair do nível 0! [+]"
        update_player_data "nivel" "1"
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
        3)
            echo -e "\n[+] Você encontrou a sala da malina! [+]"
            echo -e "[-] Após vasculhar dentro da sala, você encontrou um documento!\nDeseja abrir o documento? [s/n]"
            read -p "> " opt_sn
            if [[ "${opt_sn,,}" = "s" ]]; then
                echo -e "\n[-] Você abriu o documento! [-]"
                echo -e "[-] Nele dizia as instruções de como se movimentar entre os níveis! A forma básica de se movimentar entre os níveis é através do noclip, mas você tem uma pequena chance de ter sucesso! [-]"
            else
                echo "\n[!] Você escolheu não abrir o documento! [!]"
            fi
        ;;

        7)
            echo -e "\n[!] Você encontrou a sala vermelha! [!]"
            echo -e "[!] Infelizmente, não há uma saída aqui. Aceite seu destino! [!]"
            exit 1
        ;;

        *)
            echo "[+] Você continua andando, mas não encontra nada de interessante. [+]"
        ;;
    esac
}

# Função principal do nível 0
function main() {
    # Atualiza o nível do jogador para 0
    update_player_data "nivel" "0"

    # Exibe a descrição do nível 0
    show_level_description

    # Loop principal do nível 0
    while :; do
        echo ""
        read -p "(nivel:0)# " opt_m

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

# Inicia o nível 0
main