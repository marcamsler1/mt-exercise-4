#!/bin/bash

mkdir -p subword_models/5k

subword-nmt learn-joint-bpe-and-vocab \
  --input data/processed/train.tok.de data/processed/train.tok.it \
  -s 5000 \
  --total-symbols \
  -o subword_models/5k/bpe_5k.codes \
  --write-vocabulary subword_models/5k/bpe_5k.vocab.de subword_models/5k/bpe_5k.vocab.it

cat subword_models/5k/bpe_5k.vocab.de subword_models/5k/bpe_5k.vocab.it \
  | awk '{print $1}' | sort | uniq > subword_models/5k/bpe_5k.joint_vocab

