#!/bin/bash

VENV_DIR=venv

if [ -d $VENV_DIR ]; then
  echo "Virtual environment $VENV_DIR already exists: not doing anything."
  exit 1
fi

# Install and activate the venv
virtualenv -p python3 $VENV_DIR
source $VENV_DIR/bin/activate

# Install packages
pip install django

