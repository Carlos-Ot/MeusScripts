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

  set -e

  # ============================================
  # Função pra imprimir informação
  # ============================================
  function print_info(){
  	local amarelo="\033[33m"
  	local reset="\033[m"

  	printf "${amarelo}$1${reset}\n"
  }

  # Fazendo as atualizações iniciais
  print_info "Fazendo as atualizações iniciais..."
  sudo apt-get -y upgrade
  sudo apt-get -y dist-upgrade

  # ------------------------ Adicionando repositórios ------------------------
  print_info "Adicionando repositórios dos Dark Themes..."
  # para instalar o Arc-Theme e o Yosembiance theme
  sudo apt-add-repository ppa:noobslab/themes -y

  # para o Adapta theme
  sudo apt-add-repository ppa:tista/adapta -y

  # pacote de icones pro Adapta theme
  sudo apt-add-repository ppa:papirus/papirus -y

  print_info "Adicionando repositório do Spotify..."
  # 1. Add the Spotify repository signing keys to be able to verify downloaded packages
  sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 0DF731E45CE24F27EEEB1450EFDC8610341D9410
  # 2. Add the Spotify repository
  echo deb http://repository.spotify.com stable non-free | sudo tee /etc/apt/sources.list.d/spotify.list

  print_info "Adicionando repositório do Atom..."
  curl -L https://packagecloud.io/AtomEditor/atom/gpgkey | sudo apt-key add -
  sudo sh -c 'echo "deb [arch=amd64] https://packagecloud.io/AtomEditor/atom/any/ any main" > /etc/apt/sources.list.d/atom.list'


  # ------------------------ Baixando e instalando as coisas -----------------------
  print_info "Update..."
  sudo apt-get update

  print_info "Instalando temas..."
  sudo apt-get -y install arc-theme
  sudo apt-get -y install yosembiance-gtk-theme
  sudo apt-get -y install adapta-gtk-theme
  sudo apt-get -y install papirus-icon-theme

  # ------------------------ Baixando algumas ferramentas e utilitários ------------------------
  print_info "Instalando algumas ferramentas e utilitários..."

  # pois é, não vem por padrão instalado.
  sudo apt-get -y install zip

  # para executar o “Disk Usage Analyzer (baobab)”, usando o  “gksudo baobab”
  sudo apt-get -y install gksu

  # instalando o git
  sudo apt-get -y install git

  # instalando o meld
  sudo apt-get -y install meld

  # instalando o vim
  sudo apt-get -y install vim

  # instalando o Unity Tweak Tool
  sudo apt-get -y install unity-tweak-tool

  # instalando Spotify
  sudo apt-get install -y spotify-client

  # instalando o Atom
  sudo apt-get install -y atom

  # instalando o VLC
  sudo apt-get install vlc browser-plugin-vlc

  # Extensão Nautilus para abrir o terminal
  sudo apt-get install -y nautilus-open-terminal

  print_info "Removendo algumas coisas..."

  # removendo o Thunderbird, não uso cliente de email
  sudo apt-get -y remove thunderbird

  # removendo os games
  sudo apt-get remove aisleriot gnome-mahjongg gnome-mines gnome-sudoku



  # apt-get fix-broken
  # pra consertar possíveis dependencias e pacotes quebrados
  sudo apt-get -f -y install

  # reload nautilus
  nautilus -q

  # olhe: https://www.dropbox.com/install-linux
  print_info "======= Baixando O Dropbox ======="

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

  # reiniciando o computador
  print_info "Reiniciando o computador..."
  sudo shutdown -r now
