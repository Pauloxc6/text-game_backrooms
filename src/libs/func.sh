# Vars
export cor_game="\e[32;1m"
export nul="\e[0m"

export PLAYER_CONF="$PWD/src/db/player.conf" # Caminho do arquivo de configuração do jogador

echo -e "${cor_game}"

function historia_base(){

    echo "
Se você não é cuidadoso e se afasta da realidade nas áreas erradas, acabará nos backrooms, onde nada mais é do que o fedor do tapete úmido velho,
a loucura do mono-amarelo, o ruído de fundo infinito do fluorescente Luzes com o máximo de Hum-Buzz, e aproximadamente seiscentos milhões de quilômetros 
quadrados de salas vazias segmentadas aleatoriamente para serem presas.
Deus te salve se você ouvir algo vagando por perto, porque com certeza"

    echo ""

}

# Resgitro do player
function _register() {
    echo ""
    echo "[*] Se registre no banco de dados da equipe M.E.G [*]"
    read -p "[*] Nome: " player_name
    read -p "[*] Senha: " player_senha

    echo "[-] Aguarde a validação... [-]"
    sleep 5s

    # Validação aleatória (1 em 3 chances de sucesso)
    if [[ "$(( 1 + $RANDOM % 3 ))" -eq "3" ]]; then
        echo -e "[+] Sucesso! Seu cadastro na equipe M.E.G foi aprovado.[+]\n"

        # Cria um hash da senha (usando sha256 para segurança)
        senha_hash=$(echo -n "$player_senha" | sha256sum | cut -d' ' -f1)

        # Atualiza o arquivo player.conf
        sed -i "s/^player_name=.*/player_name=\"$player_name\"/" "$PWD/src/db/player.conf"
        sed -i "s/^player_senha=.*/player_senha=\"$senha_hash\"/" "$PWD/src/db/player.conf"

        echo "[+] Cadastro concluído! [+]"
    else
        echo -e "[!] Erro ao se cadastrar na equipe M.E.G!\nVocê não é compatível com a equipe! [!]"
    fi
}

# Login do Player
function _login() {
    # Vars Local
    local count="0"

    echo ""
    echo "[*] Login no banco de dados da M.E.G [*]"

    # Recupera os dados do arquivo player.conf
    local player_name=$(grep "^player_name=" "$PWD/src/db/player.conf" | cut -d'=' -f2 | tr -d '"')
    local player_senha=$(grep "^player_senha=" "$PWD/src/db/player.conf" | cut -d'=' -f2 | tr -d '"')

    while :; do
        read -p "[*] Nome: " l_player_name
        read -sp "[*] Senha: " l_player_senha

        # Cria um hash da senha inserida
        l_player_senha_hash=$(echo -n "$l_player_senha" | sha256sum | cut -d' ' -f1)

        # Verifica as credenciais
        if [[ "${l_player_name,,}" == "${player_name,,}" && "$l_player_senha_hash" == "$player_senha" ]]; then
            echo -e "\n[+] Sucesso ao logar no sistema da M.E.G! [+]"
            sleep 1s
            printf "\033c"
            break
        else
            let count++
            echo -e "\n[!] Erro ao logar! Tente novamente. [!]"
            [[ "$count" -eq 3 ]] && { echo "[!] Número máximo de tentativas atingido. Saindo... [!]"; exit 1 ;}
        fi
    done
}

function help(){

     echo ""
     
     echo -e "Menu de ajuda"

     echo -e "\nBásico"
     echo -e "\thelp - Menu de ajuda"
     echo -e "\texit - Sair do game\n"

     echo -e "Moviemtação"
     echo -e "\tFrente"
     echo -e "\tAtrás"
     echo -e "\tEsquerda"
     echo -e "\tDireita"

     echo ""
     echo -e "Gameplay"
     echo -e "\tUsar       - Utiliza um item"
     echo -e "\tScan       - Procura por novos itens"
     echo -e "\tStatus     - Visualize seus status atuais"
     echo -e "\tInventario - Visualize seu inventário"
     echo -e "\tNoClipping - Utilize para se movimentar entre os niveis"
     

}

function status(){
    echo ""

    local player_sanidade="$(grep "^sanidade=" "$PWD/src/db/player.conf" | cut -d'=' -f2 | tr -d '"')"
    local player_vida="$(grep "^vida=" "$PWD/src/db/player.conf" | cut -d'=' -f2 | tr -d '"')"
    local player_room="$(grep "^nivel=" "$PWD/src/db/player.conf" | cut -d'=' -f2 | tr -d '"')"

    echo "[+] Status Atuais [+]"
    echo "[^] Vida: ${player_vida}"
    echo "[^] Sanidade: ${player_sanidade}"
    echo "[^] Level: ${player_room}"
}

function sanidade() {
    echo ""

    # Recupera a sanidade atual do jogador
    local player_sanidade=$(grep "^sanidade=" "$PWD/src/db/player.conf" | cut -d'=' -f2 | tr -d '"')

    # Inicia o timer (se ainda não estiver iniciado)
    if [[ -z "$start_timer" ]]; then
        start_timer=$(date +%s)
    fi

    # Calcula o tempo decorrido
    local current_time=$(date +%s)
    local elapsed_time=$((current_time - start_timer))

    # Verifica se 60 segundos se passaram
    if [[ "$elapsed_time" -ge 60 ]]; then
        echo "[-] Você perdeu 100 de sanidade! Procure por uma água de amêndoas.[-]"

        # Reduz a sanidade do jogador
        player_sanidade=$((player_sanidade - 100))

        # Atualiza o arquivo player.conf com a nova sanidade
        sed -i "s/^sanidade=.*/sanidade=\"$player_sanidade\"/" "$PWD/src/db/player.conf"

        # Reinicia o timer
        start_timer=$(date +%s)
    fi
}

function _noclipping(){
    local random="$((1 + $RANDOM % 10))"
    local player_room="$(grep "^nivel=" "$PWD/src/db/player.conf" | cut -d'=' -f2 | tr -d '"')"
    [[ "$random" -eq "6" ]] && { echo -e "\n[+] Sucesso! Noclipping iniciado para dentro no nivel [+]" ; sleep 3s ; bash ./src/rooms/room${player_room}/room${player_room}.sh ;} || { echo "[!] Error! falha ao fazer o noclipping [!]" ;}
}

# Função para recuperar dados do jogador
function get_player_data() {
    local key=$1
    grep "^$key=" "$PLAYER_CONF" | cut -d'=' -f2 | tr -d '"'
}

# Função para atualizar dados do jogador
function update_player_data() {
    local key=$1
    local value=$2
    sed -i "s/^$key=.*/$key=\"$value\"/" "$PLAYER_CONF"
}

# Função para verificar a sanidade do jogador
function check_sanity() {
    sanidade
    local player_sanidade=$(get_player_data "sanidade")
    if [[ "$player_sanidade" -le 0 ]]; then
        echo -e "\n[!]Sua sanidade chegou a 0! Você perdeu o controle e ficou preso nas Backrooms para sempre.\n[!] Você perdeu tudo o que você tinha! [!]"
        update_player_data "player_name" ""
        update_player_data "player_senha" ""
        update_player_data "slot1" ""
        update_player_data "slot2" ""
        update_player_data "slot3" ""
        exit 1
    elif [[ "$player_sanidade" -eq "500" ]];then
        echo -e "\n[!] Sua sanidade chegou a 500! Tome cuidado você pode ficar preso para sempre nas Backrooms.[!]"
    fi
}