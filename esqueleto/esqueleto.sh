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
  #   -p, --parser    Cria um parser com um arquivo de configuração
  #
  #    NOME_DO_SCRIPT - obrigatório
  #    - Nome do script a ser criado
  #
  #   Ex.: ./esqueleto -h
  #   Ex.: ./esqueleto -p
  #   Ex.: ./esqueleto dummy_script
  #   Ex.: ./esqueleto -g dummy_script
  # ----------------------------------------------------------------------------
  # Autor: Frank Junior <frankcbjunior@gmail.com>
  # Desde: 2013-12-24
  # Versão: 3
  # ----------------------------------------------------------------------------


  # Configurações
  # ----------------------------------------------------------------------------
  # set:
  # -e: se encontrar algum erro, termina a execução imediatamente
  set -e


  # Variáveis
  # ----------------------------------------------------------------------------

  readme="README.md"
  nome_do_usuario=""
  email_do_usuario=""
  nome_do_script=""
  nome_do_parser="parser.sh"

  mensagem_help="
Uso: $(basename "$0") [OPÇÕES] <NOME_DO_SCRIPT>

OPÇÕES: - opcionais
  -h, --help  Mostra essa mesma tela de ajuda
  -g, --git   Versiona o script com git
  -p, --parser   Cria um parser com um arquivo de configuração

NOME_DO_SCRIPT - obrigatório
  - Nome do script a ser criado

Ex.: ./esqueleto -h
Ex.: ./esqueleto -p
Ex.: ./esqueleto dummy_script
Ex.: ./esqueleto -g dummy_script
  "
  mensagem_parser="
Agora que o parser foi criado, recomendo que você adicione
essas funções no seu script para usar o parser e o arquivo de configuração:

# ============================================
# função que carrega os dados do arquivo
# de configuração.
# ============================================
function init(){
  # Carregando a configuração do arquivo externo
  local chaves=\"\$(./\"\$parser_file\" \"\$config_file\")\"

  # consultando a chave
  chave=\$(retorna_valor \"\$chaves\" \"chave\")

  validacao_valores
}

# ============================================
# função para validar os valores retornados
# pelo arquivo de configuração
# ============================================
function validacao_valores(){
  # valide as chaves aqui
}

# ============================================
# funcão para pegar o valor da chave procurada
#
# Parametro 1 [\$1] = A lista de chaves do \$config_file.
# Parametro 2 [\$2] = A chave no qual deseja pegar o valor.
# ============================================
function retorna_valor(){
  local chaves=\$1
  local chave=\$2
  local linha=""
  local valor=""

  # filtrando a saída pela chave que foi passada por parametro
  linha=\$(echo -e \"\$chaves\" | grep -i \"\$chave\")

  # validação, para chave duplicada
  if [ \$(echo -e \"\$linha\" | wc -l) -gt 1 ]; then
    print_erro \"chave \$chave duplicada, no arquivo de configuração\"
    exit 1
  fi

  # pegando a somente o valor da chave, e imprimindo na saída padrão
  valor=\$(echo \"\$linha\" | cut -d \"=\" -f2 | sed 's/\\\\\"//g')

  echo \"\$valor\"
}
  "




  # Utils
  # ****************************************************************************

  # códigos de retorno
  SUCESSO=0
  ERRO=1

  # debug = 0, desligado
  # debug = 1, ligado
  debug=1

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
  # funcao de debug
  # ============================================
  function debug_log(){
    [ "$debug" = 1 ] && print_info "[DEBUG] $*"
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
  # Função que constrói o script
  # ============================================
  function criar_script(){
  echo "#!/bin/bash

  # Cabeçalho
  # ----------------------------------------------------------------------------
  # Descrição:
  #    TODO...
  #
  # ----------------------------------------------------------------------------
  # Uso:
  #    TODO..
  # ----------------------------------------------------------------------------
  # Autor: $nome_do_usuario <$email_do_usuario>
  # Desde: $(date +%d-%m-%Y)
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




  # Utils
  # ****************************************************************************

  # códigos de retorno
  SUCESSO=0
  ERRO=1

  # debug = 0, desligado
  # debug = 1, ligado
  debug=0

  # Cores
  cor_vermelho=\"\033[31m\"
  cor_verde=\"\033[32m\"
  cor_amarelo=\"\033[33m\"
  fecha_cor=\"\033[m\"

  # ============================================
  # Função pra imprimir informação
  # ============================================
  function print_info(){
    printf \"\${cor_amarelo}\$1\${fecha_cor}\n\"
  }

  # ============================================
  # Função pra imprimir mensagem de sucesso
  # ============================================
  function print_success(){
    printf \"\${cor_verde}\$1\${fecha_cor}\n\"
  }

  # ============================================
  # Função pra imprimir erros
  # ============================================
  function print_error(){
    printf \"\${cor_vermelho}[ERROR] \$1\${fecha_cor}\n\"
  }

  # ============================================
  # Função de debug
  # ============================================
  function debug_log(){
    [ \"\$debug\" = 1 ] && print_info \"[DEBUG] \$*\"
  }

  # ============================================
  # tratamento de validacoes
  # ============================================
  function validacoes(){
    echo \"\"
  }

  # ============================================
  # tratamento das exceções de interrupções
  # ============================================
  function exception(){
    echo \"\"
  }
  # ******************* [FIM] Utils *******************




  # Funções do Script
  # ----------------------------------------------------------------------------
  # ============================================
  # Função Main
  # ============================================
  function main(){
    print_info \"Ola, meu nome eh $nome_do_script\"
    echo \"\"
    print_success \"imprimindo mensagem de sucesso!\"
    print_error \"imprimindo mensagem de erro!\"
    exit \"\$SUCESSO\"
  }

  # Main
  # ----------------------------------------------------------------------------
  # trata interrrupção do script em casos de ctrl + c (SIGINT) e kill (SIGTERM)
  trap exception SIGINT SIGTERM
  validacoes
  main

  # ----------------------------------------------------------------------------
  # FIM do Script =D

  " > "$nome_do_script"
  }

  # ============================================
  # função que cria o parser.sh
  # ============================================
  function criar_parser(){
  echo "#!/bin/bash

  # Cabeçalho
  # ----------------------------------------------------------------------------
  # Descrição:
  #   Parser para ler arquivos de configuração retornando somente as flags
  #
  # ----------------------------------------------------------------------------
  # Uso:
  #   parser.sh <file.config>
  #   Ex.: ./parser.sh release.config
  # ----------------------------------------------------------------------------
  # Autor: $nome_do_usuario <$email_do_usuario>
  # Desde: $(date +%d-%m-%Y)
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
  CONFIG=\$1

  chave=""
  valor=""
  retorno=""




  # Utils
  # ****************************************************************************

  # debug = 0, desligado
  # debug = 1, ligado
  debug=0

  # Cores
  cor_vermelho=\"\033[31m\"
  cor_verde=\"\033[32m\"
  cor_amarelo=\"\033[33m\"
  fecha_cor=\"\033[m\"

  # ============================================
  # Função pra imprimir informação
  # ============================================
  function print_info(){
    printf \"\${cor_amarelo}\$1\${fecha_cor}\n\"
  }

  # ============================================
  # Função pra imprimir mensagem de sucesso
  # ============================================
  function print_success(){
    printf \"\${cor_verde}\$1\${fecha_cor}\n\"
  }

  # ============================================
  # Função pra imprimir erros
  # ============================================
  function print_error(){
    printf \"\${cor_vermelho}[ERROR] \$1\${fecha_cor}\n\"
  }

  # ============================================
  # Função de debug
  # ============================================
  function debug_log(){
    [ \"\$debug\" = 1 ] && print_info \"[DEBUG] \$*\"
  }

  # ============================================
  # tratamento de validacoes
  # ============================================
  function validacoes(){
    # O arquivo deve existir e ser legível
    if [ -z \"\$CONFIG\" ]; then
      print_error \"uso: parser arquivo.config\"
      exit 1
    elif [ ! -r \"\$CONFIG\" ]; then
      print_error \"Não consigo ler o arquivo \$CONFIG\"
      exit 1
    fi
  }

  # ============================================
  # tratamento das exceções de interrupções
  # ============================================
  function exception(){
    echo \"\"
  }
  # ******************* [FIM] Utils *******************




  # Funções do Script
  # ----------------------------------------------------------------------------
  # ============================================
  # função com o loop para extrai dados
  # de arquivos de configuração
  # ============================================
  function main(){
    # Loop para ler a linha de configuração, guardando em \$LINHA
    while read LINHA; do

      # Ignorando as linhas de comentário
      [ \"\$(echo \$LINHA | cut -c1)\" = '#' ] && continue

      # Ignorando linhas em branco
      [ \"\$LINHA\" ] || continue

      # Guardando cada palavra da linha em \$1, \$2, \$3...
      set - \$LINHA

      # Extraindo os dados (chaves sempre maiusculas)
      chave=$('echo' \$1 | tr a-z A-Z)
      shift
      valor=\$*

      # capturando cada linha do arquivo (chave e valor) e atribuindo a variavel \$retorno
      # o sed esta retirando os comentários de 1 linha
      print_success \"\$retorno\$chave=\\\"\$valor\\\"\" | sed 's/\ #.*/\"/g'

    done < \"\$CONFIG\"
  }

  # Main
  # ----------------------------------------------------------------------------
  # trata interrrupção do script em casos de ctrl + c (SIGINT) e kill (SIGTERM)
  trap exception SIGINT SIGTERM
  validacoes
  main

  " > "$nome_do_parser"

  }

  # ============================================
  # função que cria o arquivo de configuração pro parser.sh
  # ============================================
  function criar_arquivo_configuracao(){
    local nome_arquivo_config="arquivo.config"

    echo "
# Cabeçalho
# ----------------------------------------------------------------------------
# Descrição:
#   arquivo.config - arquivo de configuração
# ----------------------------------------------------------------------------

# TODO: Descrição da chave
# TODO: exemplo:
CHAVE      valor

    " > "$nome_arquivo_config"
  }

  # ============================================
  # função que cria o README.md
  # ============================================
  function criar_readme(){
    echo "$nome_do_script
  ===========

  ## Descrição

  ## Uso
  Uso: \`./"$nome_do_script"\`

  Ex: \`./"$nome_do_script"\`
  " > "$readme"
  }

  # ============================================
  # versionar o script com o git
  # ============================================
  function git_init(){
    if [ $(which git > /dev/null; echo $?) == "0" ];then
      echo "*~" > .gitignore
      git init > /dev/null
      git add "$readme" "$nome_do_script" .gitignore
      git commit -m "criado o esqueleto do $nome_do_script" > /dev/null
    fi
  }

  # ============================================
  # Função para criar o arquivo de script
  # ============================================
  function init(){
    local nome_do_diretorio=$(echo "$nome_do_script" | sed 's/\.sh//g')
    # criando o diretorio do script
    mkdir "$nome_do_diretorio"

    # entrando no diretorio do script
    cd "$nome_do_diretorio"

    # criando um arquivo em branco com o nome do script
    touch "$nome_do_script"

    # dando permissão de execução pro script
    chmod +x "$nome_do_script"

    criar_script
  }

  # ============================================
  # Função para criar o arquivo de parser
  # ============================================
  function init_parser(){
    touch "$nome_do_parser"
    chmod +x "$nome_do_parser"
    criar_parser
    criar_arquivo_configuracao
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
          init
          criar_readme
          git_init
          print_success "script $nome_do_script criado com sucesso"
          exit "$SUCESSO"
        ;;

        # Criando o parser
        -p | --parser)
          init_parser
          print_success "parser criado com sucesso"
          print_info "$mensagem_parser"
          exit "$SUCESSO"
        ;;

        # se passar só o nome do script como parametro, ele cria sem git
        *)
          nome_do_script="$1.sh"
          validacoes "$nome_do_script"
          init
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
