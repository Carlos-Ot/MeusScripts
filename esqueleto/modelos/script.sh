#!/bin/bash

  # Cabeçalho
  # ----------------------------------------------------------------------------
  # Descrição:
  #    TODO...
  #
  # ----------------------------------------------------------------------------
  # Uso:
  #    TODO..
  # ----------------------------------------------------------------------------
  # Autor: %autor% <%email%>
  # Desde: %data%
  # Versão: 1
  # ----------------------------------------------------------------------------


  # Configurações
  # ----------------------------------------------------------------------------
  # set:
  # -e: se encontrar algum erro, termina a execução imediatamente
  set -e


  # Variáveis
  # ----------------------------------------------------------------------------
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


  # Utils
  # ****************************************************************************

  # códigos de retorno
  SUCESSO=0
  ERRO=1

  # debug = 0, desligado
  # debug = 1, ligado
  debug=0

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
  # Função de debug
  # ============================================
  function debug_log(){
    [ "$debug" = 1 ] && print_info "[DEBUG] $*"
  }

  # ============================================
  # tratamento de validacoes
  # ============================================
  function validacoes(){
    return "$SUCESSO"
  }

  # ============================================
  # tratamento das exceções de interrupções
  # ============================================
  function exception(){
    return "$ERRO"
  }
  # ******************* [FIM] Utils *******************




  # Funções do Script
  # ----------------------------------------------------------------------------

  # funções específicas do script ficam aqui...

  # ============================================
  # Função Main
  # ============================================
  function main(){
    print_info "Ola, meu nome eh testando.sh"
    echo ""
    print_success "imprimindo mensagem de sucesso!"
    print_error "imprimindo mensagem de erro!"
    exit "$SUCESSO"
  }

  # ============================================
  # Função que exibe o help
  # ============================================
  function verifyHelp(){
    case "$1" in

      # mensagem de help
      -h | --help)
        print_info "$mensagem_help"
        exit "$SUCESSO"
      ;;

    esac
  }

  # Main
  # ----------------------------------------------------------------------------
  # trata interrrupção do script em casos de ctrl + c (SIGINT) e kill (SIGTERM)
  trap exception SIGINT SIGTERM
  verifyHelp "$1"
  validacoes
  main "$1"

  # ----------------------------------------------------------------------------
  # FIM do Script =D
