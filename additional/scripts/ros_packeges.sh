#!/bin/bash

sudo apt install ros-noetic-cv-camera ros-noetic-web-video-server ros-noetic-usb-cam ros-noetic-hector-trajectory-server -y

mkdir -p ~/catkin_ws/src
cd ~/catkin_ws/src

git clone https://github.com/mateusmenezes95/i2c_device_ros.git
git clone https://github.com/mateusmenezes95/mpu6050_driver