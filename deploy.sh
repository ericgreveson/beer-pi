#!/bin/bash

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

