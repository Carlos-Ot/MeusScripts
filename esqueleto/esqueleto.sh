  #!/bin/bash

  # Cabeçalho
  # ----------------------------------------------------------------------------
  # Descrição:
  #   Esqueleto de Script.
  #   Script feito para gerar uma especie de casca de script,
  #   facilitando na hora da criação de um script novo.
  #   E eu não podia deixar de fazer uma referencia ao Esqueleto do He-man =)
  #
  # ----------------------------------------------------------------------------
  # Uso:
  #    ./esqueleto [OPÇÕES] <NOME_DO_SCRIPT>
  #
  #    OPÇÕES: - opcionais
  #   -h, --help  Mostra essa mesma tela de ajuda
  #   -g, --git    Versiona o script com git
  #
  #    NOME_DO_SCRIPT - obrigatório
  #    - Nome do script a ser criado
  #
  #   Ex.: ./esqueleto -h
  #   Ex.: ./esqueleto dummy_script
  #   Ex.: ./esqueleto -g dummy_script
  # ----------------------------------------------------------------------------
  # Autor: Frank Junior <frankcbjunior@gmail.com>
  # Desde: 2013-12-24
  # Versão: 5
  # ----------------------------------------------------------------------------


  # Configurações
  # ----------------------------------------------------------------------------
  # set:
  # -e: se encontrar algum erro, termina a execução imediatamente
  set -e


  # Variáveis
  # ----------------------------------------------------------------------------

  nome_do_usuario=""
  email_do_usuario=""
  nome_do_script=""
  esqueleto_path=$(dirname "$0")

  mensagem_help="
Uso: $(basename "$0") [OPÇÕES] <NOME_DO_SCRIPT>

OPÇÕES: - opcionais
  -h, --help  Mostra essa mesma tela de ajuda
  -g, --git   Versiona o script com git

NOME_DO_SCRIPT - obrigatório
  - Nome do script a ser criado

Ex.: ./esqueleto -h
Ex.: ./esqueleto dummy_script
Ex.: ./esqueleto -g dummy_script
  "


  # Utils
  # ****************************************************************************

  # códigos de retorno
  SUCESSO=0
  ERRO=1

  # debug = 0, desligado
  # debug = 1, ligado
  debug=1

  # ============================================
  # Função pra imprimir informação
  # ============================================
  function print_info(){
    local cor_amarelo="\033[33m"
    local fecha_cor="\033[m"

    printf "${cor_amarelo}$1${fecha_cor}\n"
  }

  # ============================================
  # Função pra imprimir mensagem de sucesso
  # ============================================
  function print_success(){
    local cor_verde="\033[32m"
    local fecha_cor="\033[m"

    printf "${cor_verde}$1${fecha_cor}\n"
  }

  # ============================================
  # Função pra imprimir erros
  # ============================================
  function print_error(){
    local cor_vermelho="\033[31m"
    local fecha_cor="\033[m"

    printf "${cor_vermelho}[ERROR] $1${fecha_cor}\n"
  }

  # ============================================
  # tratamento de validacoes da criação do script
  # ============================================
  function validacoes(){

    local script=$(echo "$1" | sed 's/\.sh//')

    # se não passar nenhum parametro, dá erro
    if [ "$script" == "" ];then
      print_error "# Uso: ./esqueleto <nome_do_novo_script>"
      print_error "# Ex.: ./esqueleto dummy_script"
      exit "$ERRO"
    fi

    # verificando se o script já foi criado
    if [ -d "$script" ]; then
      print_error "Script já existe com esse nome"
      exit "$ERRO"
    fi

  }

  # ============================================
  # tratamento das excecoes de interrupções
  # ============================================
  function exception(){
    print_error "Alguem me matou com um um 'kill -9'"
    exit "$ERRO"
  }
  # ******************* [FIM] Utils *******************




  # Funções do Script
  # ----------------------------------------------------------------------------
  # ============================================
  # função que pega o nome do autor e o email
  # através das configurações do git.
  # ============================================
  function pegar_autor_email_pelo_git(){
    # pegando as configurações do git para preencher o cabeçalho.
    if [ $(which git > /dev/null; echo $?) == "0" ];then
      email_do_usuario="$(cd ~; git config --list | grep "user.email" | cut -d "=" -f2; cd - > /dev/null)"
      nome_do_usuario="$(cd ~; git config --list | grep "user.name" | cut -d "=" -f2; cd - > /dev/null)"
    # se não tiver git instalado ,coloque o nome do usuario corrente no script,
    # e coloque um TODO no email
    else
      nome_do_usuario=$(whoami)
      email_do_usuario="TODO: email@email.com"
    fi
  }

  # ============================================
  # função que cria o README.md
  # ============================================
  function criar_readme(){

  local readme='/modelos/README.md'

  # voltando pra pasta do script
  cd ..

  # copiando o readme modelo
  cp ${esqueleto_path}${readme} "$nome_do_diretorio"

  cd "$nome_do_diretorio"

  sed -i "s/%nomeDoScript%/$nome_do_script/g" README.md

  }

  # ============================================
  # versionar o script com o git
  # ============================================
  function git_init(){
    if [ $(which git > /dev/null; echo $?) == "0" ];then
      echo "*~" > .gitignore
      git init > /dev/null
      git add README.md "$nome_do_script" .gitignore
      git commit -m "criado o esqueleto do $nome_do_script" > /dev/null
    fi
  }

  # ============================================
  # Função para criar o arquivo de script
  # ============================================
  function init(){
    nome_do_diretorio=$(echo "$nome_do_script" | sed 's/\.sh//g')
    local script='/modelos/script.sh'
    local data=$(date +%d-%m-%Y)

    # criando o diretorio do script
     mkdir "$nome_do_diretorio"

    # copiando o script modelo
    cp ${esqueleto_path}${script} "$nome_do_diretorio"

    cd "$nome_do_diretorio"

    # alterando os valores
    sed -i "s/%autor%/$nome_do_usuario/" script.sh
    sed -i "s/%email%/$email_do_usuario/" script.sh
    sed -i "s/%data%/$data/" script.sh

    # renomeando o modelo para o nome certo
    mv script.sh "$nome_do_script"
  }

  # ============================================
  # Função para criar o arquivo de manpage daquele script
  # ============================================
  function createManpage(){
    local nome_da_manpage=$(echo "$nome_do_script" | sed 's/\.sh//g')
    local manpage='/modelos/manpage.1'
    local manpage_dir='manpage'
    local data=$(date "+%d %b %Y")

    mkdir "$manpage_dir"
    cd "$manpage_dir"

    cp ${esqueleto_path}${manpage} .

    sed -i "s/@nome_do_script@/$nome_do_script/" "manpage.1"
    sed -i "s/@autor@/$nome_do_usuario/" "manpage.1"
    sed -i "s/@email@/$email_do_usuario/" "manpage.1"
    sed -i "s/@data@/$data/" "manpage.1"

    # renomeando a manpage para o nome certo
    mv "manpage.1" "${nome_da_manpage}.1"
    
    cd ..
  }

  # ============================================
  # Função Main
  #
  # Param $1 e $2 = Parametros passados pro script
  # ============================================
  function main(){
    while test -n "$1"
    do
      case "$1" in

        # mensagem de help
        -h | --help)
          print_info "$mensagem_help"
          exit "$SUCESSO"
        ;;

        # Criando e versionando o script com git
        -g | --git)
          shift
          nome_do_script="$1.sh"
          validacoes "$nome_do_script"
          pegar_autor_email_pelo_git
          init
          criar_readme
          git_init
          print_success "script $nome_do_script criado com sucesso"
          exit "$SUCESSO"
        ;;

        # se passar só o nome do script como parametro, ele cria sem git
        *)
          nome_do_script="$1.sh"
          validacoes "$nome_do_script"
          pegar_autor_email_pelo_git
          init
          createManpage
          print_success "script $nome_do_script criado com sucesso"
          exit "$SUCESSO"
        ;;

      esac
      shift
    done

  }

  # Main
  # ----------------------------------------------------------------------------
  # trata interrrupção do script em casos de ctrl + c (SIGINT) e kill (SIGTERM)
  trap exception SIGINT SIGTERM

  # verifica se existe parametro.
  # se não existir, exibe o help.
  # se existir, chama o main
  if [ -z "$1" ]
  then
    print_info "$mensagem_help"
    exit "$SUCESSO"
  else
    main "$1" "$2"
  fi
