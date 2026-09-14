# Dockerfile for working through the ROS 2 "Lyrical Luth" Get-Started docs
# https://docs.ros.org/en/lyrical/Get-Started.html
#
# Starts from the prebuilt OSRF image (ros-lyrical-desktop-full on top of
# Ubuntu 26.04 "Resolute Raccoon"). The ros2_ws/ directory is NOT baked into
# this image -- it is bind-mounted from the host at run time (see
# docker-compose.yml), so edits and colcon build output persist outside the
# container.
FROM osrf/ros:lyrical-desktop-full

ENV DEBIAN_FRONTEND=noninteractive \
    ROS_DISTRO=lyrical

# ---- Dev tools for building your own packages from the tutorials ----
# ros-dev-tools already pulls in git, python3-colcon-common-extensions,
# python3-rosdep, and python3-vcstool, so we only add what it's missing:
#   build-essential  - gcc/g++/make for C++ nodes with custom CMake steps
#   python3-pip      - for tutorial deps not packaged for apt
#   nano             - convenience editor inside the container
RUN apt-get update && apt-get install -y --no-install-recommends \
        ros-dev-tools \
        build-essential \
        python3-pip \
        nano \
    && rm -rf /var/lib/apt/lists/*

# ---- Tutorial-support packages used throughout the Get-Started docs ----
# ros-jazzy-action-tutorials-interfaces was dropped -- it was removed
# upstream in the 0.35.0 release and its Fibonacci interface was folded
# into example_interfaces (already pulled in by ros-lyrical-desktop-full).
# ros-jazzy-rqt* is installed here as the ros-lyrical-rqt metapackage,
# which pulls in rqt_gui, rqt_gui_cpp, rqt_gui_py, and rqt_py_common.
RUN apt-get update && apt-get install -y --no-install-recommends \
        ros-lyrical-action-tutorials-cpp \
        ros-lyrical-action-tutorials-py \
        ros-lyrical-demo-nodes-cpp \
        ros-lyrical-demo-nodes-py \
        ros-lyrical-joint-state-publisher-gui \
        ros-lyrical-launch-testing-ament-cmake \
        ros-lyrical-launch-testing-ros \
        ros-lyrical-pendulum-control \
        ros-lyrical-pendulum-msgs \
        ros-lyrical-ros2bag \
        ros-lyrical-rosbag2-storage-default-plugins \
        ros-lyrical-rqt \
        ros-lyrical-tf2-ros \
        ros-lyrical-tf2-tools \
        ros-lyrical-tlsf \
        ros-lyrical-tlsf-cpp \
        ros-lyrical-turtlesim \
        ros-lyrical-urdf-tutorial \
        ros-lyrical-xacro \
    && rm -rf /var/lib/apt/lists/*

# ---- rosdep (image ships rosdep, just make sure sources are current) ----
RUN rosdep update || true

# ---- Entrypoint: sources ROS 2, the workspace overlay, and colcon helpers
#      for every container invocation, interactive or not ----
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# NOTE: /root/ros2_ws is created by the bind mount in docker-compose.yml,
# not here, so we only need to set it as the default working directory.
WORKDIR /root/ros2_ws

ENTRYPOINT ["/entrypoint.sh"]
CMD ["bash"]
