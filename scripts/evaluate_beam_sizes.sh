#!/bin/bash

CONFIG="configs/bpe_5k.yaml"
REF="evaluation/bpe_5k/ref.it"
OUTDIR="beam_eval_results"
mkdir -p $OUTDIR

for beam in 1 2 3 5 7 10 15 20 25; do
  echo "Beam size $beam..."
  OUTFILE="$OUTDIR/hyp_beam${beam}.txt"
  
  start=$(date +%s)
  python -m joeynmt translate configs/bpe_5k.yaml --beam_size 1 --output_path beam_eval_results/hyp_beam1.txt
  end=$(date +%s)
  
  echo "Time: $((end - start))s"
  
  echo -n "BLEU: "
  sacrebleu $REF -i $OUTFILE -m bleu | grep "BLEU"
done

