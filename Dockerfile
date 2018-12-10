FROM roslab/roslab:kinetic-nvidia

USER root

RUN apt-get update \
 && apt-get install -yq --no-install-recommends \
    libglew-dev \
    libeigen3-dev \
    ros-kinetic-opencv3 \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/stevenlovegrove/Pangolin.git /Pangolin \
 && cd /Pangolin \
 && mkdir build \
 && cd build \
 && cmake ../ \
 && make -j4 install \
 && rm -fr /Pangolin

RUN apt-get update \
  && apt-get install -yq --no-install-recommends \
    libqt4-dev \
    qt4-qmake \
    libqglviewer-dev \
    libsuitesparse-dev \
    libcxsparse3.1.4 \
    libcholmod3.0.6 \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/RainerKuemmerle/g2o.git /g2o \
 && cd /g2o \
 && mkdir build \
 && cd build \
 && cmake ../ \
 && make -j4 install \
 && rm -fr /g2o

RUN mkdir -p ${HOME}/catkin_ws/src/lvt
COPY . ${HOME}/catkin_ws/src/lvt/.
RUN cd ${HOME}/catkin_ws \
 && mv src/lvt/README.ipynb .. \
 && apt-get update \
 && /bin/bash -c "source /opt/ros/kinetic/setup.bash && rosdep update && rosdep install --as-root apt:false --from-paths src --ignore-src -r -y" \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 && /bin/bash -c "source /opt/ros/kinetic/setup.bash && catkin_make"

RUN echo "source ~/catkin_ws/devel/setup.bash" >> ${HOME}/.bashrc

RUN chown -R ${NB_UID} ${HOME}

USER ${NB_USER}
WORKDIR ${HOME}
