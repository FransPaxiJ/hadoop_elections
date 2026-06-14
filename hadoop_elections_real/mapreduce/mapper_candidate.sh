#!/bin/bash
# Entrada esperada: departamento,candidato,total_votos
awk -F',' 'NR>1 {print $2 "\t" $3}'
