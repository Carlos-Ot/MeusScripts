#!/bin/bash

  # Cabeçalho
  # ----------------------------------------------------------------------------
  # Descrição:
  #    Script para convertes arquivos de mp3 para wav.
  #
  # ----------------------------------------------------------------------------
  # Uso:
  #    ./convert_mp3_to_wav -h
  #    ./convert_mp3_to_wav /path/do/disco
  # ----------------------------------------------------------------------------
  # Autor: Frank Junior <fcbj@cesar.org.br>
  # Desde: 26-02-2018
  # Versão: 1
  #
  # ----------------------------------------------------------------------------
  # Dependências:
  # ffmpeg --> utilitário de vídeo/audio converter
  # instalação: 'sudo apt-get install ffmpeg'
  # ----------------------------------------------------------------------------


  # Configurações
  # ----------------------------------------------------------------------------
  # set:
  # -e: se encontrar algum erro, termina a execução imediatamente
  set -e


  # Variáveis
  # ----------------------------------------------------------------------------

  disco=$1

# mensagem de help
  nome_do_script=$(basename "$0")

  mensagem_help="
Uso: $nome_do_script [OPÇÕES] <NOME_DO_SCRIPT>

OPÇÕES: - opcionais
  -h, --help  Mostra essa mesma tela de ajuda

DISCO_DIRETÒRIO - obrigatório
  - Diretório do disco

Ex.: ./$nome_do_script -h
Ex.: ./$nome_do_script /path/do/disco
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

    # verificando o parâmetro
    if [ -z "$disco" ];then
      print_error "paramêtro vazio. Passe um diretório de disco."
      exit $ERRO
    fi

    # verificando o parâmetro
    if [ ! -d "$disco" ];then
      print_error "paramêtro não é um diretório. Passe um diretório de disco."
      exit $ERRO
    fi

    # instalando o ffmpeg caso não tenha instalado
    if ! type ffmpeg > /dev/null 2>&1; then
      echo "++++ instalando o ffmpeg ++++"
      sudo apt-get install -y ffmpeg
      clear
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
  # Função que converte os arquivos para wav,
  # e coloca-os em uma pasta separada chamada "wav"
  # ============================================
  function convert_files(){

    # se já existir a pasta 'wav', delete ela.
    if [ -d "$disco"/wav ];then
      rm -rf "$disco"/wav
    fi

    # criando a pasta wav
    mkdir "$disco"/wav

    print_info "convertendo os arquivos..."
    # convertendo os arquivos
    for musica in "$disco"/*.mp3 ; do
      local musica_wav="${disco}/wav/$(basename "${musica%.mp3}")"
      
      # Expanção de variável, retira a extensão do arquivo de mp3
      ffmpeg -loglevel panic -i "$musica" -acodec pcm_u8 -ar 22050 "$musica_wav".wav > /dev/null
    done

    print_info "pronto!"
  }

  # ============================================
  # Função Main
  # ============================================
  function main(){
    case "$1" in

      # mensagem de help
      -h | --help)
        print_info "$mensagem_help"
        exit "$SUCESSO"
      ;;

      # se não for help, é o caminho feliz \o/
      *)
        validacoes
        convert_files
        exit "$SUCESSO"
      ;;

    esac
  }

  # Main
  # ----------------------------------------------------------------------------
  # trata interrrupção do script em casos de ctrl + c (SIGINT) e kill (SIGTERM)
  trap exception SIGINT SIGTERM
  main "$1"

  # ----------------------------------------------------------------------------
  # FIM do Script =D
