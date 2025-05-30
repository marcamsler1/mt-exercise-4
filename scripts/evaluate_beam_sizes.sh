#!/bin/bash

CONFIG_PREFIX=configs/configs_beam_size/bpe_5k_beam
REF=evaluation/bpe_5k/ref.it
OUTDIR=beam_eval_results
mkdir -p "$OUTDIR"

for beam in 1 2 3 5 10 15 20 25; do
    echo "Beam size $beam..."

    CONFIG_FILE="${CONFIG_PREFIX}${beam}.yaml"
    OUTFILE="${OUTDIR}/hyp_beam${beam}.txt"

    if [ ! -f "$CONFIG_FILE" ]; then
        echo "❌ Config file $CONFIG_FILE not found. Skipping..."
        continue
    fi

    start=$(date +%s)

    python -m joeynmt translate "$CONFIG_FILE" --output_path "$OUTFILE"


    end=$(date +%s)

    if [ ! -f "predictions.txt" ]; then
        echo "⚠️  No predictions.txt found. Skipping BLEU eval."
        continue
    fi

    mv predictions.txt "$OUTFILE"

    echo "✅ Time: $((end - start))s"
    echo "📊 BLEU score:"
    sacrebleu "$REF" -i "$OUTFILE" -m bleu
    echo "---------------------------------------------"
done
