#/bin/bash

echo "usuario: $(whoami)"
echo "hostname: $(hostname)"
echo "SO: $(uname -o)"
echo "Distribuicao: $(lsb_release -sd)"
echo "memoria: $(free -g)G"
echo "processador: $(grep "model name" /proc/cpuinfo | uniq | cut -d ":" -f2 | sed s/\ //) x$(grep "model name" /proc/cpuinfo | wc -l)"
echo "arquitetura: $(arch)"
