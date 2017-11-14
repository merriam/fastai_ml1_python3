#!/usr/bin/env bash

export CURDIR=`pwd`
ln -sf $CURDIR/data work/data

# Make ~/.keras be out managed dotkeras
mkdir -p ~/.keras
rm -rf dot_keras && mkdir -p dot_keras
ln -sf dot_keras ~/.keras
ln -sf roebius_for_3/keras.json.for_Theano dot_keras/keras.json


