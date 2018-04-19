#!/bin/bash

################################################################################
# Descrição:
#   Script para configurações iniciais Linux.
#   Ideal para um computador recém-formatado
#
################################################################################
# Uso:
#    ./ubuntu_install.sh
#
################################################################################
# Autor: Frank Junior <frankcbjunior@gmail.com>
# Desde: 18-10-2017
# Versão: 1
################################################################################


################################################################################
# Configurações
# set:
# -e: se encontrar algum erro, termina a execução imediatamente
set -e

################################################################################
# Variáveis - todas as variáveis ficam aqui

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
# Fazendo as atualizações iniciais
# ============================================
init_updates(){
  _print_info "Fazendo as atualizações iniciais..."
  sudo apt -y upgrade
  sudo apt -y dist-upgrade
}

# ============================================
# adicionando repositórios dos Dark Themes
# ============================================
add_dark_themes(){
  _print_info "Adicionando repositórios dos Dark Themes..."
  # para instalar o Arc-Theme e o Yosembiance theme
  sudo apt-add-repository ppa:noobslab/themes -y

  # para o Adapta theme
  sudo apt-add-repository ppa:tista/adapta -y

  # pacote de icones pro Adapta theme
  sudo apt-add-repository ppa:papirus/papirus -y
}

# ============================================
# adicionando repositório do Spotify
# ============================================
add_spotify_repo(){
  _print_info "Adicionando repositório do Spotify..."
  # 1. Add the Spotify repository signing keys to be able to verify downloaded packages
  sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 0DF731E45CE24F27EEEB1450EFDC8610341D9410
  # 2. Add the Spotify repository
  echo deb http://repository.spotify.com stable non-free | sudo tee /etc/apt/sources.list.d/spotify.list
}

# ============================================
# adicionando repositório do Atom
# ============================================
add_atom_repo(){
  _print_info "Adicionando repositório do Atom..."
  curl -L https://packagecloud.io/AtomEditor/atom/gpgkey | sudo apt-key add -
  sudo sh -c 'echo "deb [arch=amd64] https://packagecloud.io/AtomEditor/atom/any/ any main" > /etc/apt/sources.list.d/atom.list'
}

# ============================================
# instalação dos Dark Themes
# ============================================
install_dark_themes(){
  _print_info "Instalando temas..."

  sudo apt -y install \
  arc-theme \
  yosembiance-gtk-theme \
  adapta-gtk-theme \
  papirus-icon-theme
}

# ============================================
# instala ferramentas e programas utils
# ============================================
install_tools(){
  _print_info "Instalando algumas ferramentas e utilitários..."

  # [curl] - comando para fazer requests. não vem instalado por padrão
  # [wget] - comando para fazer requests. não vem instalado por padrão
  # [gksu] - para executar o “Disk Usage Analyzer (baobab)”, usando o  “gksudo baobab”
  # [git]
  # [meld] - usado para os diffs do git
  # [vim]
  # [zip] - pois é, não vem instalado por padrão.
  # [unity-tweak-tool] - usado para customizar a interface gráfica
  # [atom] - IDE
  # [python-pip] - Instalador de pacotes do Python
  # [browser-plugin-vlc] - VLC
  # [nautilus-open-terminal] - plugin do nautilus para abrir o terminal

  sudo apt -y install \
  curl \
  wget \
  gksu \
  git \
  meld \
  vim \
  zip \
  unity-tweak-tool \
  spotify-client \
  atom \
  python-pip \
  browser-plugin-vlc

  _print_info "Incrementando o Atom..."
  # Install some Atom Packages
  apm install file-icons                  # Atom package to set specific file icons in tree
  apm install atom-material-ui            # Atom package to Material Design Theme
  apm install atom-material-syntax-dark   # Atom package to Material Design syntax dark
  apm install atom-beautify               # Atom package to auto formatting code [with ctrl+alt+b]

  # Python code that use to formatting Shell Script.
  # this is necessary to [atom-beautify] works
  # pip install beautysh
}

# ============================================
# remove pacotes que eu não uso
# ============================================
remove_unused_packages(){
  _print_info "Removendo algumas coisas..."

  # [thunderbird] - cliente de email que eu não Uso
  # [aisleriot gnome-mahjongg gnome-mines gnome-sudoku] - games nativos

  sudo apt -y remove \
  aisleriot gnome-mahjongg gnome-mines gnome-sudoku
}

# ============================================
# instalando o Dropbox
# ============================================
install_dropbox(){
  # olhe: https://www.dropbox.com/install-linux
  _print_info "======= Baixando O Dropbox ======="

  cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -

  dropboxFile='[Desktop Entry]
  Type=Application
  Exec=/home/@user@/.dropbox-dist/dropboxd
  Hidden=false
  NoDisplay=false
  X-GNOME-Autostart-enabled=true
  Name[en_US]=Dropbox
  Name=Dropbox
  Comment[en_US]=
  Comment=
  '
  dropboxFile=$(echo "$dropboxFile" | sed "s/@user@/$USER/")

  echo "$dropboxFile" > ~/.config/autostart/dropbox.desktop
}

# ============================================
# Função Main
# ============================================
main(){
  # updagrade inicial, por volta de uns 300 MB
  init_updates

  # Adicionando repositórios
  add_spotify_repo
  add_atom_repo
  add_dark_themes

  # Atualizando....
  _print_info "Update..."
  sudo apt update

  # Dark Themes
  install_dark_themes

  # Baixando algumas ferramentas e utilitários
  install_tools

  remove_unused_packages

  # apt fix-broken
  # pra consertar possíveis dependencias e pacotes quebrados
  sudo apt -f -y install

  # reload nautilus
  nautilus -q

  install_dropbox

  # reiniciando o computador
  print_info "Reiniciando o computador..."
  sudo shutdown -r now
}

################################################################################
# Main - execução do script

# trata interrrupção do script em casos de ctrl + c (SIGINT) e kill (SIGTERM)
trap _exception SIGINT SIGTERM

validacoes
main

################################################################################
# FIM do Script =D
