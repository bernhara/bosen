FROM resin/rpi-raspbian:stretch

LABEL maintainer="BERNHARD Raphael <raphael.bernhard@orange.com>"

ENV http_proxy=${http_proxy}
ENV https_proxy=${https_proxy}

COPY tmp_root /

RUN test -z "$skip_apt" && apt-get update

RUN test -z "$skip_apt" && apt-get install -y apt-utils

RUN test -z "$skip_apt" && apt-get install -y \
    libgcc1 \
    libc6 \
    libzmq5 \
    libgoogle-glog0v5 \
    libgflags2v5 \
    libconfig++9v5 \
    \
    libsnappy1v5 \
    libyaml-cpp0.5v5 \
    libleveldb1v5 \
    \
    libboost-thread1.62.0 \
    libboost-system1.62.0 \
    libboost-thread1.62.0

RUN test -z "$skip_apt" && apt-get install -y \
    iputils-ping \
    net-tools \
    telnet \
    netcat \
    traceroute

RUN rm -rf /tmp/*
RUN rm /core

RUN test -z "$skip_apt" && apt-get clean

#ENTRYPOINT ["/build.sh"]
