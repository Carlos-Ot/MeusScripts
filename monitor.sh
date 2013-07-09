#/bin/bash

echo "usuario: $(whoami)"
echo "hostname: $(hostname)"
echo "SO: $(uname -a | cut -d " " -f1)"
echo "Distribuicao: $(grep "DISTRIB_DESCRIPTION" /etc/lsb-release | cut -d "=" -f2 | sed s/\"//g)"
echo "memoria: $(echo "scale=2; 3755 / 1000" | bc)G"
echo "processador: $(grep "model name" /proc/cpuinfo | uniq | cut -d ":" -f2 | sed s/\ //) x$(grep "model name" /proc/cpuinfo | wc -l)"
echo "arquitetura: $(lscpu | grep "Architecture:" | sed s/\ *//g | cut -d ":" -f2)"
