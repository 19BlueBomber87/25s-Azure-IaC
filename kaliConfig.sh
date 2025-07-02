#!/bin/bash

# Get Key before running apt-get update
sudo wget https://archive.kali.org/archive-keyring.gpg -O /usr/share/keyrings/kali-archive-keyring.gpg

# Update apt cache.
sudo apt-get update

#pen tools
sudo apt-get install -y nmap
sudo apt-get install -y wireshark

#install Powershell
sudo apt-get install -y powershell

#create powershell script
sudo mkdir /usr/share/pwsh7scripts

sudo echo "Install-Module Cim -verbose *>&1" | sudo tee /usr/share/pwsh7scripts/yahoo.ps1
sudo echo "Install-Module -Name CYB3RTools -verbose *>&1" | sudo tee --append /usr/share/pwsh7scripts/yahoo.ps1
sudo echo "Write-Verbose -Message "$(uname -a)+ $(Get-Date)" -Verbose *>&1" | sudo tee /usr/share/pwsh7scripts/ComputerNameAndDate.ps1

#Execute Script
pwsh ./usr/share/pwsh7scripts/yahoo.ps1
