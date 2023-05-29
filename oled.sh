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

# Install RPI.GPIO module
sudo pip3 install RPI.GPIO

# Installing necessary fonts for PIL
sudo apt-get install ttf-dejavu

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
echo "blinkatest.py script created...Done"
sleep 5

# Create oled_test.py file
cat << EOF > oled_test.py
import time
import subprocess
from board import SCL, SDA
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

font = ImageFont.load_default()

while True:
    draw.rectangle((0, 0, width, height), outline=0, fill=0)
    cmd = "hostname -I | cut -d' ' -f1"
    IP = subprocess.check_output(cmd, shell=True).decode("utf-8")
    cmd = 'cut -f 1 -d " " /proc/loadavg'
    CPU = subprocess.check_output(cmd, shell=True).decode("utf-8")
    cmd = "free -m | awk 'NR==2{printf \"Mem: %s/%s MB %.2f%%\", $3, $2, $3*100/$2 }'"
    MemUsage = subprocess.check_output(cmd, shell=True).decode("utf-8")
    cmd = 'df -h | awk \'$NF=="/"{printf "Disk: %d/%d GB %s", $3,$2,$5}\''
    Disk = subprocess.check_output(cmd, shell=True).decode("utf-8")

    draw.text((x, top + 0), "IP: " + IP, font=font, fill=255)
    draw.text((x, top + 8), "CPU load: " + CPU, font=font, fill=255)
    draw.text((x, top + 16), MemUsage, font=font, fill=255)
    draw.text((x, top + 25), Disk, font=font, fill=255)

    disp.image(image)
    disp.show()
    time.sleep(0.1)
EOF
echo "oled_test.py script created...Done"
sleep 5

# Install adafruit-blinka
sudo pip3 install adafruit-blinka

# Reboot the Pi to make sure all configurations are applied
sudo reboot
