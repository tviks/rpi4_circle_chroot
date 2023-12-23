#!/bin/bash

name_ros_distro=noetic 
user_name=$(whoami)
echo "#######################################################################################################################"
echo ""
echo ">>> {Starting ROS Noetic Installation}"
echo ""
echo ">>> {Checking your Ubuntu version} "
echo ""
#Getting version and release number of Ubuntu
version=`lsb_release -sc`
relesenum=`grep DISTRIB_DESCRIPTION /etc/*-release | awk -F 'Ubuntu ' '{print $2}' | awk -F ' LTS' '{print $1}'`
echo ">>> {Your Ubuntu version is: [Ubuntu $version $relesenum]}"
#Checking version is focal, if yes proceed othervice quit
case $version in
  "focal" )
  ;;
  *)
    echo ">>> {ERROR: This script will only work on Ubuntu Focal (20.04).}"
    exit 0
esac

echo ""
echo ">>> {Ubuntu Focal 20.04 is fully compatible with Ubuntu Focal 20.04}"
echo ""
echo "#######################################################################################################################"
echo ">>> {Step 1: Configure your Ubuntu repositories}"
echo ""

sudo apt update

echo "New source list that will be added into this directory </etc/apt/source.list.d>"
sudo rm -rf /etc/apt/sources.list.d/ros-focal.list
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'

sudo apt install curl -y
curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -

sudo apt update

echo "Select installation ROS"
echo "     [1. desktop-full (default) ]"
echo ""
echo "     [2. desktop ]"
echo ""
echo "     [3. ros-base ]"
echo ""

read -p "Enter your install (Default is 3):" answer 

case "$answer" in
  1)
    package_type="desktop-full"
    ;;
  2)
    package_type="desktop"
    ;;
  3)
    package_type="ros-base"
    ;;
  * )
    package_type="ros-base"
    ;;
esac

#sudo apt install ros-noetic-ros-base -y
sudo apt-get install -y ros-${name_ros_distro}-${package_type} 


echo "ROS environment set up now.."

if grep  "source /opt/ros/noetic/setup.bash" ~/.bashrc
then
    echo "SKIP ADD to .bashrc"
    source ~/.bashrc
else
    echo "ADD to .bashrc"
    echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc
    source ~/.bashrc
fi

echo "Dependencies for building packages"
sudo apt install python3-rosdep python3-rosinstall python3-rosinstall-generator python3-wstool build-essential -y
sudo apt install python3-catkin-tools python3-osrf-pycommon -y

sudo rosdep init
rosdep update

