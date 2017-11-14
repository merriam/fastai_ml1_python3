#!/usr/bin/env bash

CURDIR=`pwd`

# Make ~/.keras be out managed dotkeras
rm -rf ~/.keras
mkdir dot_keras
ln -s dot_keras ~/.keras
ln -s dot_keras/keras.json roebius_for_3


