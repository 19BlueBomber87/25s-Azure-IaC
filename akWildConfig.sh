#!/bin/bash

# Update apt cache.
sudo apt-get update

#We need to add repo before installing nginx-core. Otherwise we get an error
sudo add-apt-repository main
sudo add-apt-repository universe
sudo add-apt-repository restricted
sudo add-apt-repository multiverse  

# Install Nginx.
sudo apt-get install -y nginx

# Set the home page.
curl https://raw.githubusercontent.com/19BlueBomber87/toDoApp/refs/heads/master/21s-Web-HTML5-WildNet.html -o /var/www/html/index.html


