#!/bin/bash

INPUT_DIR="data/bpe_2k"
OUTPUT_DIR="data/bpe_2k"

CODES="subword_models/2k/bpe_2k.codes"

for split in train dev test; do
  for lang in de it; do
    subword-nmt apply-bpe -c $CODES \
      < ${INPUT_DIR}/${split}.tok.${lang} \
      > ${OUTPUT_DIR}/${split}.bpe.${lang}
  done
done

echo "Applied BPE with 2k codes to ${INPUT_DIR}/*.tok.*"
