#!/usr/bin/env bash

CURDIR=`pwd`
ln -sf $CURDIR/data work/data

# Make ~/.keras be out managed dotkeras
rm -rf ~/.keras
mkdir dot_keras
ln -s dot_keras ~/.keras
ln -s roebius_for_3/keras.json.for_Theano dot_keras/keras.json


