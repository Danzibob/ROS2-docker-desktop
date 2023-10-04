#!/bin/bash

# Check if the ROS-desktop container is already running; start if not
container_id=$(docker-compose ps -q ros-desktop)
if [ -z "$container_id" ]; then
  echo "No ros-desktop container is running. Starting a new one."
  docker-compose up -d
  container_id=$(docker-compose ps -l -q ros-desktop)
  
  # Grant permissions for the X server socket
  xhost +local:$container_id

  # Revoke permissions when the container exits
  ./cleanup.sh $container_id &

else
  echo "A ros-desktop container is already running with ID: $container_id"
  echo "To start another ros-desktop container, please stop that one first"
fi
