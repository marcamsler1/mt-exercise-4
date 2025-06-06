#!/bin/bash

CONFIG_PREFIX=configs/configs_beam_size/bpe_5k_beam
OUTDIR=beam_eval_results
mkdir -p "$OUTDIR"

for beam in 1 2 3 4 5 7 10 15 20 25; do
    echo "🔍 Beam size $beam..."
    CONFIG_FILE="${CONFIG_PREFIX}${beam}.yaml"

    if [ ! -f "$CONFIG_FILE" ]; then
        echo "❌ Config file $CONFIG_FILE not found. Skipping..."
        continue
    fi

    start=$(date +%s)
    python -m joeynmt test "$CONFIG_FILE"
    end=$(date +%s)

    echo "⏱️  Time taken: $((end - start)) seconds"
    echo "---------------------------------------------"
done
