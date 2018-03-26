FROM resin/rpi-raspbian:stretch

LABEL maintainer="BERNHARD Raphael <raphael.bernhard@orange.com>"

ENV http_proxy=${http_proxy}
ENV https_proxy=${https_proxy}

COPY tmp_root /

RUN test -z "$skip_apt" && apt-get update

RUN test -z "$skip_apt" && apt-get install -y apt-utils

RUN test -z "$skip_apt" && apt-get install -y \
    iputils-ping \
    net-tools \
    telnet \
    netcat \
    traceroute

RUN test -z "$skip_apt" && apt-get install -y libgcc1
RUN test -z "$skip_apt" && apt-get install -y libc6
RUN test -z "$skip_apt" && apt-get install -y libzmq5
#!! RUN test -z "$skip_apt" && apt-get install -y libboost-thread1
RUN test -z "$skip_apt" && apt-get install -y libgoogle-glog0v5
RUN test -z "$skip_apt" && apt-get install -y libgflags2v5
RUN test -z "$skip_apt" && apt-get install -y libconfig++9v5

RUN test -z "$skip_apt" && apt-get install -y libsnappy1v5
RUN test -z "$skip_apt" && apt-get install -y libyaml-cpp0.5v5
RUN test -z "$skip_apt" && apt-get install -y libleveldb1v5

RUN test -z "$skip_apt" && apt-get install -y libboost-system1.62.0
RUN test -z "$skip_apt" && apt-get install -y libboost-thread1.62.0

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
