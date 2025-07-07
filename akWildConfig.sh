#!/bin/bash

# Update apt cache.
sudo apt-get -y update

#We need to add repo before installing nginx-core. Otherwise we get an error
sudo add-apt-repository -y main
sudo add-apt-repository -y universe
sudo add-apt-repository -y restricted
sudo add-apt-repository -y multiverse  

#Update Sed
sudo apt-get install -y sed

# Install Nginx.
sudo apt-get install -y nginx
