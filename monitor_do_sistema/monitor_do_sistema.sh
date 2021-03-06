#!/bin/bash
# ----------------------------------------------------------------------------
# Monitor do Sistema
#
# Uso: ./monitor
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

# cores
cor_amarelo="\033[33m"
fecha_cor="\033[m"

# Funcoes
# ----------------------------------------------------------------------------

# imprime msg amarelo
function print_info(){
echo -e "${cor_amarelo}"$1"${fecha_cor}"$2""
}

# funcao para verificar o SO corrente e chamar seus respectivos comandos
function verifica_so(){
local current_so="$(uname -s)"
local memoria_valor=""

case "$current_so" in
		Linux)
			# comandos do Linux
			usuario_comando="\t"$(whoami)" - "$(uptime | cut -d " " -f4-5 | sed s/,//)""
			hostname_comando="\t"$(hostname)""
			SO_comando="\t\t"$(uname -s)""
			distribuicao_comando="\t"$(lsb_release -sd)" - ($(lsb_release -sc))"
			memoria_valor=$(free -m | grep "Mem" | awk '{print $2}')
			memoria_comando="\t$(echo "scale=2; $memoria_valor/1000" | bc) GB"
			processador_comando="\t"$(grep "model name" /proc/cpuinfo | uniq | cut -d ":" -f2 | sed s/\ //)"\
					x"$(grep "model name" /proc/cpuinfo | wc -l)""
			arquitetura_comando="\t"$(arch)""
			;;
		Darwin)
			# comandos do Mac
			usuario_comando="\t"$(whoami)" - "$(uptime | cut -d " " -f5-6 | sed s/,//)""
			hostname_comando="\t"$(hostname)""
			computador_comando="\t$(get_info_mac 'SPHardwareDataType' 'Model Name')"
			versao_comando="\t\t$(get_info_mac 'SPSoftwareDataType' 'System Version')"
			memoria_comando="\t$(get_info_mac 'SPHardwareDataType' 'Memory')"
			processador_comando="\t$(get_info_mac 'SPHardwareDataType' 'Processor Name') \
				$(get_info_mac 'SPHardwareDataType' 'Processor Speed')"
			arquitetura_comando="\t"$(arch)""
			;;
		cygwin)
			# comandos do Cygwin
			usuario_comando="ainda nao implementado"
			hostname_comando="ainda nao implementado"
			SO_comando="ainda nao implementado"
			distribuicao_comando="ainda nao implementado"
			memoria_comando="ainda nao implementado"
			processador_comando="ainda nao implementado"
			arquitetura_comando="ainda nao implementado"
			echo "estou no cygwin"
			;;
		*)
			echo "Sistema Operacional incompatível com o script"
			exit 1
			;;
esac
}

# funcao para pegar as informacoes do MacOS baseado no 'system_profiler'
function get_info_mac(){
	system_profiler "$1" | grep "$2" | cut -d ":" -f2 | cut -c2-
}

# Main
# ----------------------------------------------------------------------------

verifica_so

print_info "usuario:" "${usuario_comando}"
print_info "hostname:" "${hostname_comando}"
if [ $(uname -s) = 'Linux' ]; then
	print_info "SO:" "${SO_comando}"
	print_info "distribuicao:" "${distribuicao_comando}"
elif [ $(uname -s) = 'Darwin' ]; then
	print_info "computador:" "${computador_comando}"
	print_info "versao:" "${versao_comando}"
fi
print_info "memoria:" "${memoria_comando}"
print_info "processador:" "${processador_comando}"
print_info "arquitetura:" "${arquitetura_comando}"


