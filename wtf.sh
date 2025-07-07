#!/bin/bash
sudo sed -i "s/Custom Heading Size and Font Type/Welcome to Azure <br>Computer Name: $host<br>OS Version: $opsys<br>Date: $today<br>CPU:$cpu<br>IP: $printIPvar/g" /var/www/html/index.html