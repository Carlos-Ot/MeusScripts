#!/bin/bash

  # Cabeçalho
  # ----------------------------------------------------------------------------
  # Descrição:
  #   Parser para ler arquivos de configuração retornando somente as flags
  #
  # ----------------------------------------------------------------------------
  # Uso:
  #   parser.sh <arquivo.config>
  #   Ex.: ./parser.sh arquivo.config
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
  # O arquivo de configuração é indicado na linha de comando
  CONFIG=$1
  retorno=




  # Utils
  # ****************************************************************************

  # debug = 0, desligado
  # debug = 1, ligado
  debug=0

  # Cores
  cor_vermelho="\033[31m"
  cor_verde="\033[32m"
  cor_amarelo="\033[33m"
  fecha_cor="\033[m"

  # ============================================
  # Função pra imprimir informação
  # ============================================
  function print_info(){
    printf "${cor_amarelo}$1${fecha_cor}\n"
  }

  # ============================================
  # Função pra imprimir mensagem de sucesso
  # ============================================
  function print_success(){
    printf "${cor_verde}$1${fecha_cor}\n"
  }

  # ============================================
  # Função pra imprimir erros
  # ============================================
  function print_error(){
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
    # O arquivo deve existir e ser legível
    if [ -z "$CONFIG" ]; then
      print_error "uso: parser arquivo.config"
      exit 1
    elif [ ! -r "$CONFIG" ]; then
      print_error "Não consigo ler o arquivo $CONFIG"
      exit 1
    fi
  }

  # ============================================
  # tratamento das exceções de interrupções
  # ============================================
  function exception(){
    echo ""
  }
  # ******************* [FIM] Utils *******************




  # Funções do Script
  # ----------------------------------------------------------------------------
  # ============================================
  # função com o loop para extrai dados
  # de arquivos de configuração
  # ============================================
  function main(){
    # Loop para ler a linha de configuração, guardando em $LINHA
    while read LINHA; do

      # Ignorando as linhas de comentário
      [ "$(echo $LINHA | cut -c1)" = '#' ] && continue

      # Ignorando linhas em branco
      [ "$LINHA" ] || continue

      # Guardando cada palavra da linha em $1, $2, $3...
      set - $LINHA

      # Extraindo os dados (chaves sempre maiusculas)
      chave=$1
      shift
      valor=$*

      # capturando cada linha do arquivo (chave e valor) e atribuindo a variavel $retorno
      # o sed esta retirando os comentários de 1 linha
      print_success "$retorno$chave=\"$valor\"" | sed 's/\ #.*/"/g'

    done < "$CONFIG"
  }

  # Main
  # ----------------------------------------------------------------------------
  # trata interrrupção do script em casos de ctrl + c (SIGINT) e kill (SIGTERM)
  trap exception SIGINT SIGTERM
  validacoes
  main
