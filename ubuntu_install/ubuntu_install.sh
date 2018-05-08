#!/bin/bash

################################################################################
# Descrição:
#   Script to initial configs to Ubuntu 18.04 Minimal Installation.
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
  sudo apt -y update
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
# adicionando repositório do LibreOffice
# ============================================
add_libreOffice_repo(){
  _print_info "Adicionando repositório do LibreOffice..."
  sudo add-apt-repository ppa:libreoffice/ppa -y
}

# ============================================
# adicionando repositório do Transmission
# ============================================
add_transmission_repo(){
  _print_info "Adicionando repositório do Transmission..."
  sudo add-apt-repository ppa:transmissionbt/ppa -y
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
# Instala o Telegram Desktop
# ============================================
install_telegram(){
  _print_info "Instalando Telegram Desktop..."
  # fazendo donwload do Telegram
  wget https://telegram.org/dl/desktop/linux
  # Dessa forma de cima, o donwload vai ser feito com um arquivo sem extensão
  # chamado de 'linux'. Com isso é preciso renomear ele pra um arquivo .tar.xz.
  # nesse caso, eu já estou movendo o arquivo pro $HOME
  mv "linux" "$HOME/telegram.tar.xz"
  cd ~ > /dev/null
  # extraindo o arquivo compactado
  tar -xf telegram.tar.xz
  # deletando o arquivo
  rm telegram.tar.xz
  cd - > /dev/null

  _print_success "O Telegram foi instalado em $HOME/Telegram"

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
  # [transmission] - torrent client
  # [libreOffice] - packages about LibreOffice
  # [unity-tweak-tool] - usado para customizar a interface gráfica
  # [atom] - IDE
  # [python-pip] - Instalador de pacotes do Python
  # [browser-plugin-vlc] - VLC
  # [ubuntu-restricted-extras] - pacotes extras do Ubuntu: mp3 codec, font tts da Microsoft....

  sudo apt -y install \
  curl \
  wget \
  gksu \
  git \
  meld \
  vim \
  zip \
  transmission \
  libreoffice-gtk2 libreoffice-gnome \
  unity-tweak-tool \
  spotify-client \
  atom \
  python-pip \
  browser-plugin-vlc \
  ubuntu-restricted-extras

  _print_info "Incrementando o Atom..."
  # Install some Atom Packages
  apm install file-icons                  # Atom package to set specific file icons in tree
  apm install atom-material-ui            # Atom package to Material Design Theme
  apm install atom-material-syntax-dark   # Atom package to Material Design syntax dark
  apm install atom-beautify               # Atom package to auto formatting code [with ctrl+alt+b]

  # Python code that use to formatting Shell Script.
  # this is necessary to [atom-beautify] works
  # pip install beautysh

  install_telegram
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
# limpa dependencias
# ============================================
clean_dependencies(){
  # apt fix-broken
  # pra consertar possíveis dependencias e pacotes quebrados
  sudo apt -f -y install
  # remover pacotes não mais utilizados
  sudo apt-get autoremove -y
  # deletar os pacotes .deb em '/var/cache/apt/archives/'
  sudo apt-get clean -y
}

# ============================================
# mostrar o banner inicial
# ============================================
show_header(){
cat << "EOF"
   __  ____                __           ____           __        ____
  / / / / /_  __  ______  / /___  __   /  _/___  _____/ /_____ _/ / /
 / / / / __ \/ / / / __ \/ __/ / / /   / // __ \/ ___/ __/ __ `/ / /
/ /_/ / /_/ / /_/ / / / / /_/ /_/ /  _/ // / / (__  ) /_/ /_/ / / /
\____/_.___/\__,_/_/ /_/\__/\__,_/  /___/_/ /_/____/\__/\__,_/_/_/

EOF
}

# ============================================
# Função Main
# ============================================
main(){
  # updagrade inicial, por volta de uns 300 MB
  init_updates

  _print_info "------------------------------"
  _print_info "Adicionando repositórios"
  _print_info "------------------------------"
  echo ""

  add_spotify_repo
  add_atom_repo
  add_dark_themes
  add_libreOffice_repo
  add_transmission_repo

  # Atualizando....
  _print_info "Update..."
  sudo apt update

  # Dark Themes
  install_dark_themes

  # Baixando algumas ferramentas e utilitários
  install_tools

  clean_dependencies

  install_dropbox

  # descomente essa linha para instalar os pacotes de dev também.
  # ./development_install.sh

  # reiniciando o computador
  print_info "Reiniciando o computador..."
  sudo shutdown -r now
}

################################################################################
# Main - execução do script

# trata interrrupção do script em casos de ctrl + c (SIGINT) e kill (SIGTERM)
trap _exception SIGINT SIGTERM

validacoes
show_header
main

################################################################################
# FIM do Script =D
