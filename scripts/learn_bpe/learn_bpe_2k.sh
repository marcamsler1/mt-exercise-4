#!/bin/bash

mkdir -p subword_models

subword-nmt learn-joint-bpe-and-vocab \
  --input data/processed/train.tok.de data/processed/train.tok.it \
  -s 2000 \
  --total-symbols \
  -o subword_models/bpe_2k.codes \
  --write-vocabulary subword_models/bpe_2k.vocab.de subword_models/bpe_2k.vocab.it

cat subword_models/bpe_2k.vocab.de subword_models/bpe_2k.vocab.it \
  | awk '{print $1}' | sort | uniq > subword_models/bpe_2k.joint_vocab

