#!/bin/bash

source /root/.nvm/nvm.sh
source /usr/share/gazebo/setup.sh
source /opt/ros/humble/setup.bash
cd ~/gzweb
npm start > /dev/null &
rosrun gazebo_ros gzserver
