#!/bin/bash

SRC_PATH=$(dirname $0)
INSTALL_PATH=/srv/beer-pi

# Check we are root
if [ $UID != 0 ]; then
  echo "You must run this script as root!"
  exit 1
fi

echo "Deploying into $INSTALL_PATH..."
if [ ! -d $INSTALL_PATH ]; then
  mkdir $INSTALL_PATH
fi

# Install venv
cd $INSTALL_PATH
cp $SRC_PATH/create_venv.sh .
if [ ! -d venv ]; then
  source create_venv.sh
fi

# Copy Django project
cp -r $SRC_PATH/beer $INSTALL_PATH

# Fix permissions

