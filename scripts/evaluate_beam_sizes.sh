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
    python -m joeynmt test "$CONFIG_FILE" --output_path "abc"

    PRED_FILE="${OUTDIR}/beam${beam}.test"  # this is where test predictions will be saved

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
