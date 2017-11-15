#!/usr/bin/env bash

cd ~/fastai
ln -sf dot_bash_profile ~/.bash_profile
ln -sf `pwd`/data work/data
mkdir -p ~/.keras 2> /dev/null
ln -sf roebius_for_3/keras.json.for_Theano ~/.keras/keras.json
mkdir -p ~/.jupyter 2> /dev/null
ln -sf dot_jupyter_slash_jupyter_notebook_config.py ~/.jupyter/jupyter_notebook_config.py



