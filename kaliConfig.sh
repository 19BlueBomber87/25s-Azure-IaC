#!/bin/bash

# Get Key before running apt-get update
sudo wget https://archive.kali.org/archive-keyring.gpg -O /usr/share/keyrings/kali-archive-keyring.gpg

# Update apt cache.
sudo apt-get update
