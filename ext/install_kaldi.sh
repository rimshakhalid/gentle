#!/bin/bash

cd kaldi
git checkout 498b25db122ec68a96aee154b9d829030adfae4c
cd ..

# Prepare Kaldi
cd kaldi/tools
# make clean
make
./extras/install_openblas.sh
cd ../src
# make clean (sometimes helpful after upgrading upstream?)
./configure --static --static-math=yes --static-fst=yes --use-cuda=no --openblas-root=../tools/OpenBLAS/install
make depend
cd ../../
