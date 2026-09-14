#!/bin/bash
# shellcheck disable=SC1090,SC1091
set -e

# Source ROS 2 setup
source /opt/ros/"$ROS_DISTRO"/setup.bash

# Source the local workspace (if it has been built)
if [ -f "/root/ros2_ws/install/setup.bash" ]; then
    source "/root/ros2_ws/install/setup.bash"
fi

# Setup colcon_cd
if [ -f /usr/share/colcon_cd/function/colcon_cd.sh ]; then
    source /usr/share/colcon_cd/function/colcon_cd.sh
    export _colcon_cd_root=/opt/ros/"$ROS_DISTRO"/
fi

# Setup colcon tab completion
if [ -f /usr/share/colcon_argcomplete/hook/colcon-argcomplete.bash ]; then
    source /usr/share/colcon_argcomplete/hook/colcon-argcomplete.bash
fi

exec "$@"
