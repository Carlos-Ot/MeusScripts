Convert MP3 to WAV.
===========

[![tool](https://img.shields.io/badge/tool-ffmpeg-brightgreen.svg)](https://img.shields.io/badge/tool-ffmpeg-brightgreen.svg)
[![so](https://img.shields.io/badge/OS-Linux-brightgreen.svg)](https://img.shields.io/badge/OS-Linux-brightgreen.svg)

## Descrição
Convert music files in .mp3 to .wav, to prepare music files to upload in [oneRPM](https://www.onerpm.com/).

OneRPM need a file music master (that song that was recorded in the studio) with 44100 Hz of sample rate.

This script was written in Shell for Linux and use [ffmpeg](https://www.ffmpeg.org/) as tool to convert files. The script convert all files .mp3 in a directory and create a new directory call 'wav' with all files .wav inside.

## Uso
```console
# Download
curl -L https://raw.githubusercontent.com/frankjuniorr/MeusScripts/master/convert_mp3_to_wav/convert_mp3_to_wav.sh > convert_mp3_to_wav.sh
chmod +x convert_mp3_to_wav.sh

# execute
./convert_mp3_to_wav /path/of/disc
```
