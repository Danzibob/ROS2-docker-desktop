## About
This repository provides a docker-compose file and a set of scripts to run ROS in a container while making use of X Server.

## Prerequisites
- docker
- docker-compose
- A linux device running the X display server

## Instructions
1. Copy the scripts in this repository into your project directory
        This directory will be mounted by the container.
2. Run `./start.sh` to open a new container. This command will start a shell in the container.
3. Run `new_terminal.sh` to open a new terminal into the same container
4. Exit shells as normal by using `exit` or `Ctrl-D`
5. The container will stop when the initial shell session (started by `start.sh`) ends