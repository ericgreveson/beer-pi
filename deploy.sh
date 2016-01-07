#!/bin/bash

SRC_PATH=$(dirname $(readlink -f $0))
INSTALL_PATH=/var/www/beer
WWW_USER=www-data
WWW_GROUP=www-data

# Check we are root
if [ $UID != 0 ]; then
  echo "You must run this script as root!"
  exit 1
fi

# Stop webserver if running
service apache2 stop

# Install prerequisites
source $SRC_PATH/scripts/prerequisites.sh

# Deploy webserver settings (and set correct path)
cp scripts/beer.vhost /etc/apache2/sites-available/
sed -i "s|@INSTALL_PATH@|${INSTALL_PATH}|g" /etc/apache2/sites-available/beer.vhost
rm -f /etc/apache2/sites-enabled/000-default
ln -s /etc/apache2/sites-available/beer.vhost /etc/apache2/sites-enabled/000-default

# Deploy code and scripts
echo "Deploying into $INSTALL_PATH..."
FRESH_INSTALL=1
if [ -d $INSTALL_PATH ]; then
  read -p "Completely blat existing installation and its venv? " -n 1 -r
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    rm -rf $INSTALL_PATH
  else
    FRESH_INSTALL=0
  fi
fi

INSTALL_VENV=0
if [ $FRESH_INSTALL -eq 1 ]; then
  # Create from scratch
  echo "Creating fresh install in $INSTALL_PATH..."
  mkdir $INSTALL_PATH
  chmod g+s $INSTALL_PATH
  INSTALL_VENV=1
else
  # Delete everything but the venv (takes forever to copy)
  echo "Removing old project files but leaving the venv in $INSTALL_PATH...."
  cd $INSTALL_PATH
  rm -rf $(ls * | grep -v venv)
fi

# Copy Django project
cp -r $SRC_PATH/beer/* $INSTALL_PATH

if [ $INSTALL_VENV -eq 1 ]; then
  # Install venv
  cd $INSTALL_PATH
  source ./create_venv.sh
fi

# Fix permissions
chown -R $WWW_USER:$WWW_GROUP $INSTALL_PATH

# Enable the server
service apache2 start
