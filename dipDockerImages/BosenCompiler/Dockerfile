# -*- mode: indented-text -*-

FROM debian:stretch-slim

RUN \
    apt-get update && \
    apt-get upgrade -y

RUN \
    apt-get install -y  \
    	    git

RUN \
    mkdir /PETUUM

WORKDIR /PETUUM

RUN \
    git clone https://github.com/sailing-pmls/third_party.git /PETUUM/third_party && \
    ls -l /PETUUM

RUN \
    apt-get install -y  \
    	    g++ \
	    libc6 \
	    libzmq5-dev \
	    libgoogle-glog-dev \
	    libgflags-dev \
	    libconfig++-dev \
	    \
	    libsnappy-dev \
	    libyaml-cpp-dev \
	    libleveldb-dev \
	    \
	    libboost-thread-dev \
	    \
	    libeigen3-dev

RUN \
    apt-get install -y  \
    	    git \
	    make
	    
RUN \
    ls -l /PETUUM

COPY tmp_root/ /PETUUM/

RUN \
    ls -l /PETUUM

RUN \
    cd /PETUUM/bosen && \
    ls -l && \
    rm -rf third_party && \
    ln -s /PETUUM/third_party . && \
    ls -l

RUN \
    cd /PETUUM/bosen/third_party && \
    make cuckoo && \
    cp central/zmq.hpp include

RUN \
    cd /PETUUM/bosen && \
    cp defns.mk.template defns.mk

RUN \
    cd /PETUUM/bosen && \
    make clean && \
    make -j 3

RUN \
    cd /PETUUM/bosen/app/mlr && \
    make clean && \
    make -j 3

