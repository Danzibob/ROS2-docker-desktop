#!/bin/bash

# Check if the ROS-desktop container is already running; start if not
container_id=$(docker-compose ps -q)
if [ -z "$container_id" ]; then
  echo "No gazebo-web container is running. Starting a new one..."
  docker-compose up -d
  container_id=$(docker-compose ps -q)

  # Grant permissions for the X server socket
  xhost "+local:$container_id"

  # Open an interactive terminal in the container
  ./new_terminal.sh
  # Continues once the interactive session ends

  echo "Main terminal session closed, stopping and cleaning up container..."

  # stop container & revoke xhost perms
  docker-compose kill
  xhost "-local:$container_id"

  echo "Done!"

else
  # Open a terminal session in the existing container
  echo "A ros-desktop container is already running with ID: $container_id"
  echo "Starting an interactive terminal session in that container..."
  ./new_terminal.sh
  printf "\nContainer was closed! Exiting..."
fi
