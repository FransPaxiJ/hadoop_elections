#!/bin/bash
# Emite candidato -> 1 por cada voto
awk -F',' 'NR>1 {print $4 "\t1"}'
