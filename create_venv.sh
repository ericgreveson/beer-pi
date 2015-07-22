#!/bin/bash

VENV_DIR=venv

if [ -d $VENV_DIR ]; then
  echo "Virtual environment $VENV_DIR already exists: not recreating."
else
  virtualenv -p python3 $VENV_DIR
fi

# Install and activate the venv
source $VENV_DIR/bin/activate

# Install packages
pip install django gunicorn

