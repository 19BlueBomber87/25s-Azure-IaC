#!/bin/bash

# Update apt cache.
sudo apt-get update

# Get Key
sudo wget https://archive.kali.org/archive-keyring.gpg -O /usr/share/keyrings/kali-archive-keyring.gpg

#install Powershell
sudo apt-get install -y powershell

#create powershell script
echo "Install-Module Cim -verbose *>&1" > yahoo.ps1
echo "Install-Module -Name CYB3RTools-verbose *>&1" >> yahoo.ps1
Write-Verbose -Message "$(uname -a)+ $(Get-Date)" -Verbose *>&1  > ComputerNameAndDate.ps1

#Execute Script
pwsh ./yahoo.ps1
