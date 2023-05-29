#!/bin/bash

# Update and upgrade the Pi
sudo apt-get update
sudo apt-get upgrade

# Install python3-pip if not installed
if ! command -v pip3 &> /dev/null
then
    sudo apt-get install python3-pip
fi

# Install adafruit-circuitpython-ssd1306
sudo pip3 install adafruit-circuitpython-ssd1306

# Install python3-pil
sudo apt-get install python3-pil

# Upgrade setuptools
sudo pip3 install --upgrade setuptools

# Change directory to home
cd ~

# Install adafruit-python-shell
sudo pip3 install --upgrade adafruit-python-shell

# Download the raspi-blinka.py script
wget https://raw.githubusercontent.com/adafruit/Raspberry-Pi-Installer-Scripts/master/raspi-blinka.py

# Run the script
sudo python3 raspi-blinka.py

# Check I2C and SPI devices
ls /dev/i2c* /dev/spi*

# Create blinkatest.py file
cat << EOF > blinkatest.py
import board
import digitalio
import busio

print("Hello blinka!")

# Try to great a Digital input
pin = digitalio.DigitalInOut(board.D4)
print("Digital IO ok!")

# Try to create an I2C device
i2c = busio.I2C(board.SCL, board.SDA)
print("I2C ok!")

# Try to create an SPI device
spi = busio.SPI(board.SCLK, board.MOSI, board.MISO)
print("SPI ok!")

print("done!")
EOF

echo "Script finished successfully"
