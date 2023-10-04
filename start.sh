#!/bin/bash

# Choose podman-compose or docker-compose
if command -v podman-compose &> /dev/null; then
    COMPOSE_CMD="podman-compose"
elif command -v docker-compose &> /dev/null; then
    COMPOSE_CMD="docker-compose"
else
    echo "Neither docker-compose nor podman-compose found. Exiting."
    exit 1
fi

# Check if the ROS-desktop container is already running; start if not
container_id=$(docker ps -q -f name=ros-desktop)
if [ -z "$container_id" ]; then
  echo "No ros-desktop container is running. Starting a new one."
  $COMPOSE_CMD up -d
  container_id=$(docker ps -l -q)
  
  # Grant permissions for the X server socket
  xhost +local:$container_id

  # Open an interactive terminal in the container
  ./new_terminal.sh

  # Once the interactive session ends, stop container & revoke xhost perms
  docker stop -t 0 $container_id
  xhost -local:$container_id
else
  echo "A ros-desktop container is already running with ID: $container_id"
  echo "To start another ros-desktop container, please stop that one first"
fi
