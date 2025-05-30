#!/bin/bash

CONFIG_PREFIX=configs/configs_beam_size/bpe_5k_beam
OUTDIR=beam_eval_results
REF=evaluation/bpe_5k/ref.it
mkdir -p "$OUTDIR"

for beam in 1 2 3 5 10 15 20 25; do
    echo "Beam size $beam..."
    CONFIG_FILE="${CONFIG_PREFIX}${beam}.yaml"

    if [ ! -f "$CONFIG_FILE" ]; then
        echo "❌ Config file $CONFIG_FILE not found. Skipping..."
        continue
    fi

    start=$(date +%s)
    python -m joeynmt test "$CONFIG_FILE"
    end=$(date +%s)

    PRED_FILE="models/bpe_5k_de_it/test_predictions.txt"
    if [ ! -f "$PRED_FILE" ]; then
        echo "⚠️  No $PRED_FILE found. Skipping BLEU eval."
        continue
    fi

    cp "$PRED_FILE" "$OUTFILE"

    echo "✅ Time: $((end - start))s"
    echo "📊 BLEU score:"
    sacrebleu "$REF" -i "$OUTFILE" -m bleu
    echo "---------------------------------------------"
done

