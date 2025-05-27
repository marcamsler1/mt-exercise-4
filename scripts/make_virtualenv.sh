#! /bin/bash

scripts=$(dirname "$0")
base=$scripts/../..


python -m venv $base/venvs/torch3

echo "To activate your environment:"
echo "    source $base/venvs/torch3/Scripts/activate"
