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

  # ============================================
  # Fazendo as atualizações iniciais
  # ============================================
  function init_updates(){
    print_info "Fazendo as atualizações iniciais..."
    sudo apt -y upgrade
    sudo apt -y dist-upgrade
  }

  # ============================================
  # adicionando repositórios dos Dark Themes
  # ============================================
  function add_dark_themes(){
    print_info "Adicionando repositórios dos Dark Themes..."
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
  function add_spotify_repo(){
    print_info "Adicionando repositório do Spotify..."
    # 1. Add the Spotify repository signing keys to be able to verify downloaded packages
    sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 0DF731E45CE24F27EEEB1450EFDC8610341D9410
    # 2. Add the Spotify repository
    echo deb http://repository.spotify.com stable non-free | sudo tee /etc/apt/sources.list.d/spotify.list
  }

  # ============================================
  # adicionando repositório do Atom
  # ============================================
  function add_atom_repo(){
    print_info "Adicionando repositório do Atom..."
    curl -L https://packagecloud.io/AtomEditor/atom/gpgkey | sudo apt-key add -
    sudo sh -c 'echo "deb [arch=amd64] https://packagecloud.io/AtomEditor/atom/any/ any main" > /etc/apt/sources.list.d/atom.list'
  }

  # ============================================
  # instalação dos Dark Themes
  # ============================================
  function install_dark_themes(){
    print_info "Instalando temas..."

    sudo apt -y install \
    arc-theme \
    yosembiance-gtk-theme \
    adapta-gtk-theme \
    papirus-icon-theme \
  }

  # ============================================
  # instala ferramentas e programas utils
  # ============================================
  function install_tools(){
    print_info "Instalando algumas ferramentas e utilitários..."

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
    browser-plugin-vlc \
    nautilus-open-terminal

    print_info "Incrementando o Atom..."
    # Install some Atom Packages
    apm install \
    file-icons \                # Atom package to set specific file icons in tree
    atom-material-ui \          # Atom package to Material Design Theme
    atom-material-syntax-dark \ # Atom package to Material Design syntax dark
    atom-beautify               # Atom package to auto formatting code [with ctrl+alt+b]

    # atualizando o python-pip
    pip install --upgrade pip

    # Python code that use to formatting Shell Script.
    # this is necessary to [atom-beautify] works
    pip install beautysh
  }

  # ============================================
  # remove pacotes que eu não uso
  # ============================================
  function remove_unused_packages(){
    print_info "Removendo algumas coisas..."

    # [thunderbird] - cliente de email que eu não Uso
    # [aisleriot gnome-mahjongg gnome-mines gnome-sudoku] - games nativos

    sudo apt -y remove \
    thunderbird \
    aisleriot gnome-mahjongg gnome-mines gnome-sudoku
  }

  # ============================================
  # instalando o Dropbox
  # ============================================
  function install_dropbox(){
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
  }




# ------------------------------ MAIN ------------------------------
  # updagrade inicial, por volta de uns 300 MB
  init_updates

  # Adicionando repositórios
  add_spotify_repo
  add_atom_repo

  # Atualizando....
  print_info "Update..."
  sudo apt update

  # Dark Themes - por padrão vem comentando, caso queira, descomente
  # add_dark_themes
  # install_dark_themes

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
