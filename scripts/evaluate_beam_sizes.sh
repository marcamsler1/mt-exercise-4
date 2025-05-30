#!/bin/bash

# Set model name and config path
MODEL_NAME="bpe_5k_de_it"
CONFIG="configs/config_bpe_5k.yaml"
OUTPUT_DIR="beam_eval_results"
REFERENCE="evaluation/bpe_5k/ref.it"
BEAM_SIZES=(1 2 3 4 5 7 10 15 20 25)

mkdir -p $OUTPUT_DIR

BLEU_LOG="$OUTPUT_DIR/bleu_scores.csv"
TIME_LOG="$OUTPUT_DIR/times.csv"

echo "beam_size,bleu_score" > $BLEU_LOG
echo "beam_size,time_seconds" > $TIME_LOG

echo "Evaluating beam sizes..."

for BEAM in "${BEAM_SIZES[@]}"; do
    echo "Beam size $BEAM..."

    HYP_FILE="$OUTPUT_DIR/hyp_beam${BEAM}.txt"
    
    START_TIME=$(date +%s)

    # Translate using joeynmt with specific beam size
    joeynmt translate $CONFIG \
        --output_path $HYP_FILE \
        --beam_size $BEAM \
        --n_best 1 > /dev/null

    END_TIME=$(date +%s)
    DURATION=$((END_TIME - START_TIME))

    # Detokenize hypothesis if needed, or use directly
    # Run BLEU evaluation
    BLEU=$(sacrebleu $REFERENCE -i $HYP_FILE -m bleu -b)

    echo "$BEAM,$BLEU" >> $BLEU_LOG
    echo "$BEAM,$DURATION" >> $TIME_LOG
done

echo "Done. Results saved to:"
echo "  - $BLEU_LOG"
echo "  - $TIME_LOG"
