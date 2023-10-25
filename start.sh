#!/bin/bash

# Check if the ROS-desktop container is already running; start if not
container_id=$(docker ps -q -f name=ros-desktop)
if [ -z "$container_id" ]; then
  echo "No ros-desktop container is running. Starting a new one..."
  docker-compose up -d
  container_id=$(docker ps -l -q)
  
  # Grant permissions for the X server socket
  xhost +local:$container_id

  # Open an interactive terminal in the container
  ./new_terminal.sh
  # Continues once the interactive session ends

  echo "Main terminal session closed, stopping and cleaning up container..."
  
  # stop container & revoke xhost perms
  docker stop -t 0 $container_id
  xhost -local:$container_id
  
  echo "Done!"
  
else
  # Open a terminal session in the existing container
  echo "A ros-desktop container is already running with ID: $container_id"
  echo "Starting an interactive terminal session..."
  ./new_terminal.sh
  printf "\nContainer was closed! Exiting..."
fi
