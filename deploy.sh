#!/bin/bash

SRC_PATH=$(dirname $0)
INSTALL_PATH=/srv/beer

# Check we are root
if [ $UID != 0 ]; then
  echo "You must run this script as root!"
  exit 1
fi

# Stop webserver if running
service apache2 stop

# Install prerequisites
source $SRC_PATH/scripts/prerequisites.sh

# Deploy webserver settings
cp scripts/beer.vhost /etc/apache2/sites-available/
rm -f /etc/apache2/sites-enabled/000-default
ln -s /etc/apache2/sites-available/beer.vhost /etc/apache2/sites-enabled/000-default

# Deploy code and scripts
echo "Deploying into $INSTALL_PATH..."
if [ -d $INSTALL_PATH ]; then
  echo "Blat existing installation?"
  read -p "Are you sure? " -n 1 -r
  if [[ ! $REPLY =~ ^[Yy]$ ]]
  then
    exit 1
  fi
  rm -rf $INSTALL_PATH
fi
mkdir $INSTALL_PATH

# Copy Django project
cp -r $SRC_PATH/beer/* $INSTALL_PATH

# Install venv
cd $INSTALL_PATH
if [ ! -d venv ]; then
  source create_venv.sh
fi

# Fix permissions

# Enable the site
service apache2 start
