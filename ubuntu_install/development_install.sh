#!/bin/bash

################################################################################
#
# Descrição:
#    Script usado para instalar o ambiente de desenvolvimento ná máquina
#
################################################################################
#
# Uso:
#    ./developmnent_install.sh
#
################################################################################
#
# Autor: Frank Junior <frankcbjunior@gmail.com>
# Desde: 19-04-2018
# Versão: 1
#
################################################################################


################################################################################
# Configurações
# set:
# -e: se encontrar algum erro, termina a execução imediatamente
  set -e


################################################################################
# Variáveis - todas as variáveis ficam aqui

# as variaveis ficam aqui...

  # mensagem de help
    nome_do_script=$(basename "$0")

    mensagem_help="
  Uso: $nome_do_script [OPÇÕES] <NOME_DO_SCRIPT>

  Descrição: .....

  OPÇÕES: - opcionais
    -h, --help  Mostra essa mesma tela de ajuda

  PARAM - obrigatório
    - descrição do PARAM

  Ex.: ./$nome_do_script -h
  Ex.: ./$nome_do_script PARAM
  "


################################################################################
# Utils - funções de utilidades

  # códigos de retorno
  # [condig-style] constantes devem começar com 'readonly'
  readonly SUCESSO=0
  readonly ERRO=1

  # debug = 0, desligado
  # debug = 1, ligado
  debug=0

  # ============================================
  # Função pra imprimir informação
  # ============================================
  _print_info(){
    local amarelo="\033[33m"
    local reset="\033[m"

    printf "${amarelo}$1${reset}\n"
  }

  # ============================================
  # Função pra imprimir mensagem de sucesso
  # ============================================
  _print_success(){
    local verde="\033[32m"
    local reset="\033[m"

    printf "${verde}$1${reset}\n"
  }

  # ============================================
  # Função pra imprimir erros
  # ============================================
  _print_error(){
    local vermelho="\033[31m"
    local reset="\033[m"

    printf "${vermelho}[ERROR] $1${reset}\n"
  }

  # ============================================
  # Função de debug
  # ============================================
  _debug_log(){
    [ "$debug" = 1 ] && _print_info "[DEBUG] $*"
  }

  # ============================================
  # tratamento das exceções de interrupções
  # ============================================
  _exception(){
    return "$ERRO"
  }

################################################################################
# Validações - regras de negocio até parametros

  # ============================================
  # tratamento de validacoes
  # ============================================
  validacoes(){
    return "$SUCESSO"
  }

################################################################################
# Funções do Script - funções próprias e específicas do script

# ============================================
# Instala o Android Studio
# ============================================
  android_studio_install(){
    _print_info "Instalando o Android Studio..."

    # libs necessárias para a instalação do Android Studio
    sudo apt install libc6:i386 libncurses5:i386 libstdc++6:i386 lib32z1 libbz2-1.0:i386

    # 1. baixando o html do site de download do Android developer
    # 2. grep [-m 1] busca pela 1º ocorrência
    # 2.1 [--after-context=X] onde X é o numero de linhas impressas a mais, além da busca
    # 3. buscando pelo 'href'
    # 4. o cut pega apenas a url do link
    # 5. removendo as aspas
    link_download=$(curl --silent https://developer.android.com/studio/index.html |\
     grep -m 1 --after-context=1 "linux-bundle" |\
     grep "href" |\
     cut -d "=" -f2 |\
     sed 's/\"//g')

     # fazendo download do arquivo zip do Android Studio
     wget --no-check-certificate --no-cookies --header \
     "Cookie: oraclelicense=accept-securebackup-cookie" "$link_download"

     #TODO extrair do zip
     #+ colocar no diretório correto (~/android_ambiente/android_studio)
     #+ executar o script studio.sh
  }

  # ============================================
  # Função Main
  # ============================================
  main(){
    sudo apt update

    # instalando o Node
    sudo apt install nodejs npm

    # instalando Java8 através do instalador
    sudo ./java_install.sh

    android_studio_install
  }

  # ============================================
  # Função que exibe o help
  # ============================================
  verifyHelp(){
    case "$1" in

      # mensagem de help
      -h | --help)
        _print_info "$mensagem_help"
        exit "$SUCESSO"
      ;;

    esac
  }

################################################################################
# Main - execução do script

  # trata interrrupção do script em casos de ctrl + c (SIGINT) e kill (SIGTERM)
  trap _exception SIGINT SIGTERM
  verifyHelp "$1"
  validacoes
  main "$1"

################################################################################
# FIM do Script =D
