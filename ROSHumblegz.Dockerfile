# Use the specified gazebo image as the base image
# FROM gazebo:libgazebo11
FROM osrf/ros:humble-desktop

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Install gazebo-classic
RUN apt-get update \
    && apt-get install -y --no-install-recommends gazebo \
    && rm -rf /var/lib/apt/lists/*

# Add ROS2 package repos & install ros2 gazebo plugins
RUN apt-get install -y curl gnupg2 lsb-release
RUN curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key  -o /usr/share/keyrings/ros-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(lsb_release -sc) main" | tee -a /etc/apt/sources.list.d/ros2.list \
    && apt-get update \
    && apt-get install -y \
    ros-humble-gazebo* \
    ros-humble-cartographer \
    ros-humble-cartographer-ros \
    ros-humble-navigation2 \
    ros-humble-nav2-bringup \
    ros-humble-dynamixel-sdk \
    ros-humble-turtlebot3-msgs \
    ros-humble-turtlebot3 \
    ros-humble-turtlebot3-gazebo

# Install the turtlebot3 simulation package
RUN . /usr/share/gazebo/setup.sh && . /opt/ros/humble/setup.sh \
    && mkdir /root/turtlebot3_ws \
    && cd /root/turtlebot3_ws \
    && git clone -b humble-devel https://github.com/ROBOTIS-GIT/turtlebot3_simulations.git src \
    && colcon build --symlink-install

# Load ROS shell environment by default
RUN chmod 0755 /usr/share/gazebo/setup.sh /opt/ros/humble/setup.bash
RUN echo 'source /usr/share/gazebo/setup.sh\n\
source /opt/ros/humble/setup.bash\n\
export ROS_DOMAIN_ID=30 #TURTLEBOT3\n\
export TURTLEBOT3_MODEL=waffle_pi' >> ~/.bashrc
