#!/bin/bash
# Emite ciudad|candidato -> 1 por cada voto
awk -F',' 'NR>1 {print $2 "|" $4 "\t1"}'
