#!/bin/bash
#Define characters
host=$(hostname)
opsys=$(uname -v)
ip_address=$(ip a | grep 'inet ' | awk '{print $2}')
cpu=$(lscpu | grep 'Model name')
host=$(hostname)
today=$(date +%m-%d-%Y)
#Fix illegal characters
printIPvar=$(echo $ip_address | tr '/', '-')
sudo sed -i "s/Custom Heading Size and Font Type/wtf/g" "/var/www/html/index.html"
