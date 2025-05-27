#! /bin/bash

scripts=$(dirname "$0")
base=$scripts/..

data=$base/data

# download preprocessed data

curl -L https://files.ifi.uzh.ch/cl/archiv/2020/mt20/data.ex5.tar.gz --output $base/data.ex5.tar.gz
tar -xzf $base/data.ex5.tar.gz

rm $base/data.ex5.tar.gz

# sizes
echo "Sizes of data files:"
wc -l $data/*

# sanity checks
echo "At this point, please make sure that 1) number of lines are as expected, 2) language suffixes are correct and 3) files are parallel"
