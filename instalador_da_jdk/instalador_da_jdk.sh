#!/bin/bash
# ----------------------------------------------------------------------------
# Instala o JDK no Ubuntu
#
# Uso: sudo ./instaladorJava
#
# Autor: Frank Junior <frankcbjunior@gmail.com>
# Desde: 2013-07-22
# Versão: 1
# ----------------------------------------------------------------------------

# Configurações
# ----------------------------------------------------------------------------

# set:
# -e: se encontrar algum erro, termina a execução imediatamente
set -e

# Variáveis
# ----------------------------------------------------------------------------

#path onde o java será instalado
path_java="/usr/lib/jvm"
#pacote .tar.gz
jdk_tar_gz=""

# versões que serão instaladas do JDK
jdk_64bits='jdk-8u131-linux-x64.tar.gz'
jdk_32bits='jdk-8u131-linux-i586.tar.gz'

# URL de download dosJDK
jdk_url_64bits='http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/'$jdk_64bits
jdk_url_32bits='http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/'$jdk_32bits

# Funções
# ----------------------------------------------------------------------------

# faz o donwload do JDK
function baixar_jdk(){
	wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" "$1"
}

function validacoes(){
# verifica se o script foi rodado com sudo
if [ ! $(id -u) -eq 0 ];then
		echo "rode o script com sudo"
		exit 1
fi

# Verifica a arquitetura do SO e faz o download do tar.gz
echo "baixando JDK"
if [ $(arch) = 'x86_64' ];then
	baixar_jdk "$jdk_url_64bits"
	jdk_tar_gz="$jdk_64bits"
else
	baixar_jdk "$jdk_url_32bits"
	jdk_tar_gz="$jdk_32bits"
fi

# verificando se o path já existe
if [ ! -d $path_java ]; then
	echo "criando diretório java em $path_java"
	mkdir -p $path_java
fi
}

#Informando ao Ubuntu aonde sua instalação do Java está localizada
function install_location(){
echo "informando onde está sua localização padrão do java"
update-alternatives --install "/usr/bin/javac" "javac" "$path_java/$java/bin/javac" 1
update-alternatives --install "/usr/bin/java" "java" "$path_java/$java/bin/java" 1
}

#Informando ao Ubuntu que esse é a sua instalação default de Java
function install_set_default(){
echo "Informando que essa é sua instalação default do java"
update-alternatives --set "javac" "$path_java/$java/bin/javac"
update-alternatives --set "java" "$path_java/$java/bin/java"
}

#atualizando o path no /etc/profile
function update_profile(){
echo "" >> /etc/profile
echo "#------- instalação do java -------" >> /etc/profile
echo "JAVA_HOME=$path_java/java" >> /etc/profile
echo 'PATH=$PATH:$JAVA_HOME/bin' >> /etc/profile
echo 'export JAVA_HOME' >> /etc/profile
echo 'export PATH' >> /etc/profile

#reload no /etc/profile
. /etc/profile
}

# Main
# ----------------------------------------------------------------------------

validacoes

# pegando o nome do diretorio que o tar.gz vai extrair
java=$(tar -tf $jdk_tar_gz | cut -d "/" -f1 | uniq)
# movendo o tar.gz para o diretorio de instalação do java
mv $jdk_tar_gz $path_java
#entrando no path
cd $path_java
# extraindo todos os .tar.gz
tar -xzvf *.tar.gz
#deletando todos os tar.gz
rm *.tar.gz

install_location
install_set_default
update_profile

echo "JDK instalado com sucesso"
