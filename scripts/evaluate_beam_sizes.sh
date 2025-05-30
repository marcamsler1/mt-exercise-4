#!/bin/bash

CONFIG="configs/bpe_5k.yaml"
REF="evaluation/bpe_5k/ref.it"
OUTDIR="beam_eval_results"
mkdir -p $OUTDIR

for beam in 1 2 3 5 7 10 15 20 25; do
  echo "Beam size $beam..."
  OUTFILE="$OUTDIR/hyp_beam${beam}.txt"
  
  start=$(date +%s)
  python -m joeynmt translate $CONFIG --beam_size $beam --output_path $OUTFILE
  end=$(date +%s)
  
  echo "Time: $((end - start))s"
  
  echo -n "BLEU: "
  sacrebleu $REF -i $OUTFILE -m bleu | grep "BLEU"
done

