#!/bin/bash
# Suma conteos para cada clave
awk -F'\t' '
{
  key=$1
  val=$2
  if (key == prev) {
    sum += val
  } else {
    if (prev != "") print prev "\t" sum
    prev = key
    sum = val
  }
}
END {
  if (prev != "") print prev "\t" sum
}'
