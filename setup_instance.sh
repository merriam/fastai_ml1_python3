#!/usr/bin/env bash

conda create -n fast3 python=3.6 anaconda jupyter pytest typing scikit-learn scikit-image Theano tornado anaconda pillow cython sympy bcolz pandas
mkdir ~/fastai && cd ~/fastai
git clone https://github.com/merriam/fastai_ml1_python3 fastai
