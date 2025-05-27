#!/bin/bash

mkdir -p data/processed

# Subsample + Tokenize
paste data/train.de-it.de data/train.de-it.it | shuf | head -n 100000 > data/processed/train.100k.txt

cut -f1 data/processed/train.100k.txt | sacremoses -l de tokenize > data/processed/train.tok.de
cut -f2 data/processed/train.100k.txt | sacremoses -l it tokenize > data/processed/train.tok.it

# Tokenize dev/test
for split in dev test; do
  sacremoses -l de tokenize < data/${split}.de-it.de > data/processed/${split}.tok.de
  sacremoses -l it tokenize < data/${split}.de-it.it > data/processed/${split}.tok.it
done