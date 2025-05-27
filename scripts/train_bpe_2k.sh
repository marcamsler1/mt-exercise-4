#! /bin/bash

scripts=$(dirname "$0")
base=$scripts/..

models=$base/models
configs=$base/configs
logs=$base/logs

model_name="bpe_2k_de_it"
config_name="config_bpe_2k"

mkdir -p $models
mkdir -p $logs
mkdir -p $models/$model_name
mkdir -p $logs/$model_name

num_threads=4

# measure time

SECONDS=0

OMP_NUM_THREADS=$num_threads python -m joeynmt train $configs/$config_name.yaml > $logs/$model_name/out 2> $logs/$model_name/err

echo "time taken:"
echo "$SECONDS seconds"
