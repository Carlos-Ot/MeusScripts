#!/bin/bash

# Cabeçalho
# ----------------------------------------------------------------------------
# Esqueleto de Script.
# Script feito para gerar uma especie de casca de script,
# facilitando na hora da criação de um script novo.
# E eu não podia deixar de fazer uma referencia ao Esqueleto do He-man =)
#
# Uso: ./esqueleto <nome_do_novo_script>
# Ex.: ./esqueleto dummy_script
#
# Autor: Frank Junior <frankcbjunior@gmail.com>
# Desde: 2013-12-24
# Versão: 1
# ----------------------------------------------------------------------------

# Configurações
# ----------------------------------------------------------------------------
# set:
# -e: se encontrar algum erro, termina a execução imediatamente
set -e

# Variáveis
# ----------------------------------------------------------------------------
# debug = 0, desligado
# debug = 1, ligado
debug=0

nome_do_script="$1.sh"
readme="README.md"
nome_do_usuario=""
email_do_usuario=""

# Funcoes
# ----------------------------------------------------------------------------
# funcao de debug
function debug_log(){
	[ "$debug" = 1 ] && echo "[DEBUG] $*"
}

function validacoes(){
	# se não passar nenhum parametro, dá erro
	if [ "$nome_do_script" == "" ];then
		echo "# Uso: ./esqueleto <nome_do_novo_script>"
		echo "# Ex.: ./esqueleto dummy_script"
		exit 1
	fi

	# verificando se o script já foi criado
	if [ -d $nome_do_script ]; then
		echo "Script já existe com esse nome"
		exit 1
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

# Função que cria as linhas do script
function criar_script(){

echo "#!/bin/bash

# Cabeçalho
# ----------------------------------------------------------------------------
# TODO: Descrição...
#
# Uso:
# Ex.:
#
# Autor: $nome_do_usuario <$email_do_usuario>
# Desde: $(date +%Y-%m-%d)
# Versão: 1
# ----------------------------------------------------------------------------

# Configurações
# ----------------------------------------------------------------------------

# set:
# -e: se encontrar algum erro, termina a execução imediatamente
set -e

# Variáveis
# ----------------------------------------------------------------------------

# debug = 0, desligado
# debug = 1, ligado
debug=0

# Cores
cor_vermelho=\"\033[31m\"
cor_verde=\"\033[32m\"
cor_amarelo=\"\033[33m\"
fecha_cor=\"\033[m\"

# Funções
# ----------------------------------------------------------------------------

# **** Utils
# usada pra imprimir informação
function print_info(){
	printf \"\${cor_amarelo}\$1\${fecha_cor}\n\"
}

# usada pra imprimir mensagem de sucesso
function print_success(){
	printf \"\${cor_verde}\$1\${fecha_cor}\n\"
}

# usada pra imprimir erros
function print_error(){
	printf \"\${cor_vermelho}\$1\${fecha_cor}\n\"
}

# funcao de debug
function debug_log(){
	[ \"\$debug\" = 1 ] && print_info \"[DEBUG] \$*\"
}
# **** [FIM] Utils


# tratamento de validacoes
function validacoes(){
	echo \"\"
}

# tratamento das excecoes de interrupcoes
function exception(){
	echo \"\"
}

# funcao main
function main(){
	print_info \"Ola, meu nome eh $nome_do_script\"
	echo \"\"
	print_success \"imprimindo mensagem de sucesso!\"
	print_error \"imprimindo mensagem de erro!\"
}

# Main
# ----------------------------------------------------------------------------

# trata interrrupção do script em casos de ctrl + c (SIGINT) e kill (SIGTERM)
trap exception SIGINT SIGTERM
validacoes
main

" > "$nome_do_script"
}

# função que cria as linhas do README.md
function criar_readme(){
	echo "$nome_do_script
===========

## Descrição

## Uso
Uso: \`./"$nome_do_script"\`

Ex: \`./"$nome_do_script"\`
" > "$readme"
}

# versionar o script com o git
function git_init(){
	if [ $(which git > /dev/null; echo $?) == "0" ];then
		echo "*~" > .gitignore
		git init > /dev/null
		git add "$readme" "$nome_do_script" .gitignore
		git commit -m "criado o esqueleto do $nome_do_script" > /dev/null
	fi
}

function main(){
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
	criar_readme
	git_init

	echo "script "$nome_do_script" criado com sucesso"
}

# Main
# ----------------------------------------------------------------------------
validacoes
main
