check_music_file_format
===========

## Descrição
Script para checkar o formato de nomeclatura de toda a pasta de música.
Passando a lista de .mp3 por parâmetro 
(atráves do comando: `find <pasta_de_musica> -iname "*.mp3" > musicas.txt`)

OBS: Levando em consideração que a árvore do diretório de música
já está de acordo com os padrões do [MusicOrganizer](https://github.com/frankjuniorr/MusicOrganizer).

## Dependências
* [**lib_alfred**](https://github.com/frankjuniorr/lib_alfred)

## Uso
Uso: `./check_music_file_format <lista_de_musicas>`

Ex: `./check_music_file_format musicas.txt`

