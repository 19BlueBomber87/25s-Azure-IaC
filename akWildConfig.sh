#!/bin/bash

# Update apt cache.
sudo apt-get update

#We need to add repo before installing nginx-core. Otherwise we get an error
sudo add-apt-repository -y main
sudo add-apt-repository -y universe
sudo add-apt-repository -y restricted
sudo add-apt-repository -y multiverse  

#Update Sed
sudo apt-get upgrade -y sed

# Install Nginx.
sudo apt-get install -y nginx

# Set the web page.
sudo curl https://raw.githubusercontent.com/19BlueBomber87/25s-Azure-IaC/refs/heads/main/html/azurehome.html -o '/var/www/html/index.html'

sudo mkdir /var/www/html/jpg

sudo curl "https://raw.githubusercontent.com/19BlueBomber87/25s-Azure-IaC/refs/heads/main/html/cert.jpg" -o '/var/www/html/jpg/cert.jpg'
sudo curl "https://raw.githubusercontent.com/19BlueBomber87/toDoApp/refs/heads/master/jpg/AquaMoose.jpg" -o '/var/www/html/jpg/AquaMoose.jpg'
sudo curl "https://raw.githubusercontent.com/19BlueBomber87/toDoApp/refs/heads/master/jpg/babymoose2.jpg" -o '/var/www/html/jpg/babymoose2.jpg'
sudo curl "https://raw.githubusercontent.com/19BlueBomber87/toDoApp/refs/heads/master/jpg/bull.jpg" -o '/var/www/html/jpg/bull.jpg'
sudo curl "https://raw.githubusercontent.com/19BlueBomber87/toDoApp/refs/heads/master/jpg/bunny.jpg" -o '/var/www/html/jpg/bunny.jpg'
sudo curl "https://raw.githubusercontent.com/19BlueBomber87/toDoApp/refs/heads/master/jpg/bunny2.jpg" -o '/var/www/html/jpg/bunny2.jpg'

#Define characters
host=$(hostname)
opsys=$(uname -v)
ip_address=$(ip a | grep 'inet ' | awk '{print $2}')
cpu=$(lscpu | grep 'Model name')
host=$(hostname)

today=$(date +%m-%d-%Y)

#Fix illegal characters
printIPvar=$(echo $ip_address | tr '/', '-')

#update web page
sudo sed -i "s/Custom Heading Size and Font Type/Welcome to Azure <br>Computer Name: $host<br>OS Version: $opsys<br>Date: $today<br>CPU:$cpu<br>IP: $printIPvar/g" /var/www/html/index.html
