#!/bin/bash

################################################################################
#
# Descrição:
#    TODO...
#
################################################################################
#
# Uso:
#    TODO..
#
################################################################################
#
# Autor: %autor% <%email%>
# Desde: %data%
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

  # funções específicas do script ficam aqui...

  # ============================================
  # Função Main
  # ============================================
  main(){
    _print_info "Ola, meu nome eh testando.sh"
    echo ""
    _print_success "imprimindo mensagem de sucesso!"
    _print_error "imprimindo mensagem de erro!"
    exit "$SUCESSO"
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
