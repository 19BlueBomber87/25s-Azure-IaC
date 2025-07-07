#!/bin/bash
sudo echo 'Model name: Intel(R) Xeon(R) Platinum 8171M CPU @ 2.60GHz'
#Define characters
host=$(hostname)
opsys=$(uname -v)
ip_address=$(ip a | grep 'inet ' | awk '{print $2}')
cpu=$(lscpu | grep 'Model name' | awk '{print $3, $4,$5,$6,$7, $8, $9}')
host=$(hostname)
today=$(date +%m-%d-%Y)
#Fix illegal characters
printIPvar=$(echo $ip_address | tr '/', '-')
echo "Welcome to Azure <br>Computer Name: $host<br>OS Version: $opsys<br>Date: $today<br>CPU:$cpu<br>IP: $printIPvar"
sudo sed -i "s/Custom Heading Size and Font Type/Welcome to Azure <br>Computer Name: $host<br>OS Version: $opsys<br>Date: $today<br>CPU:$cpu<br>IP: $printIPvar/g" /var/www/html/index.html
