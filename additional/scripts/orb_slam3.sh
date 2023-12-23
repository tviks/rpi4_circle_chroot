#!/bin/bash

#sudo apt-get install htop net-tools libboost-all-dev libboost-dev libssl-dev libpython2.7-dev libeigen3-dev ninja-build -y

cd ~
git clone --recursive https://github.com/stevenlovegrove/Pangolin.git
cd Pangolin || exit 1
#bash ./scripts/install_prerequisites.sh recommended -y

cmake -B build -GNinja
cmake --build build




#cd ~
#git clone https://github.com/UZ-SLAMLab/ORB_SLAM3.git ORB_SLAM3
#cd ORB_SLAM3
#chmod +x build.sh
#sed -i 's/++11/++14/g' CMakeLists.txt
#./build.sh

