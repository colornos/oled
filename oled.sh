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

# Install RPI.GPIO module
sudo pip3 install RPI.GPIO

# Installing necessary fonts for PIL
sudo apt-get install fonts-dejavu

# Create blinkatest.py file
cat << EOF > blinkatest.py
import board
import digitalio
import busio

print("Hello blinka!")

# Try to create a Digital input
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
echo "blinkatest.py script created... Done"
sleep 5

# Create oled_test.py file
cat << EOF > oled_test.py
import time
import digitalio
from board import SCL, SDA, D17
import busio
from PIL import Image, ImageDraw, ImageFont
import adafruit_ssd1306

i2c = busio.I2C(SCL, SDA)
disp = adafruit_ssd1306.SSD1306_I2C(128, 32, i2c)

disp.fill(0)
disp.show()

width = disp.width
height = disp.height
image = Image.new("1", (width, height))

draw = ImageDraw.Draw(image)
draw.rectangle((0, 0, width, height), outline=0, fill=0)

padding = -2
top = padding
bottom = height - padding
x = 0

font_path = "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf"  # Update the path if necessary
font_size = 18  # Choose a font size
font = ImageFont.truetype(font_path, font_size)

screens = ["Weight", "Temperature", "Heartrate", "Blood Pressure", "Glucose", "Blood Oxygen", "Cholestrol(HDL)", "Cholestrol(LDL)"]
screen_index = 0

button = digitalio.DigitalInOut(D17)
button.direction = digitalio.Direction.INPUT
button.pull = digitalio.Pull.UP

while True:
    draw.rectangle((0, 0, width, height), outline=0, fill=0)
    draw.text((x, top), screens[screen_index], font=font, fill=255)

    disp.image(image)
    disp.show()

    if not button.value:
        screen_index += 1
        if screen_index >= len(screens):
            screen_index = 0
        time.sleep(0.2)

EOF
echo "oled_test.py script created... Done"
sleep 5

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

# Reboot the Pi to make sure all configurations are applied
sudo reboot
