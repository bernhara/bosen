# -*- mode: indented-text -*-

FROM debian:stretch-slim

LABEL maintainer="BERNHARD Raphael <raphael.bernhard@orange.com>"

RUN \
    apt-get update && \
    apt-get upgrade -y  \
    && \
    apt-get clean && \
    rm -rf /tmp/* && \
    rm -f /core


RUN \
    apt-get update && \
    apt-get install -y  \
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
            libboost-system1.62.0 \
            libboost-thread1.62.0 && \
    apt-get clean && \
    rm -rf /tmp/* && \
    rm -f /core

RUN \
    apt-get update && \
    apt-get install -y  \
    	    python3-pip \
    && \
    apt-get clean && \
    rm -rf /tmp/* && \
    rm -f /core

# mandatory for pip
ENV LC_ALL=en_US.utf8 LANG=en_US.utf8
ENV LC_ALL=C.UTF-8 LANG=C.UTF-8

RUN \
    /usr/bin/python3 -m pip --no-cache-dir install pipenv

#
# copy everything from the prebuilt root to /
#

#
# copy each python project Pipfile which needs it's own python interpreter to be regenerated
#
COPY tmp_root/home/dip/bin/misc/pushToElastic/Pipfile /home/dip/bin/misc/pushToElastic/

# generate Python virtual env
RUN mkdir /home/dip/bin/misc/pushToElastic/.venv
RUN \
    cd /home/dip/bin/misc/pushToElastic && \
    PIPENV_COLORBLIND=yes pipenv --bare --clear install --deploy --python /usr/bin/python3 && \
    rm -r ${HOME}/.cache

#
# Install user provided components
#

#
# Install dataset
#
COPY tmp_root/home/dip/datasets/ /home/dip/datasets/

#
# Install user code
# =================
#
RUN \
    apt-get update && \
    apt-get install -y  \
    	    curl \
    && \
    apt-get clean && \
    rm -rf /tmp/* && \
    rm -f /core

COPY tmp_root/home/dip/bin/misc/pushToElastic /home/dip/bin/misc/pushToElastic/

# copy binary files
COPY tmp_root/home/dip/bin/mlr_main /home/dip/bin/ 

# copy needed scripts
COPY tmp_root/home/dip/bin/mlrWrapper.sh /home/dip/bin/ 
COPY tmp_root/home/dip/bin/trainWorker.sh /home/dip/bin/
COPY tmp_root/home/dip/bin/testit.sh /home/dip/bin/
COPY tmp_root/home/dip/bin/pushStatsToElkLoop.sh /home/dip/bin/

CMD ["/home/dip/bin/testit.sh"]

ENV STATS_ELASTICSEARCH_URL=

ENV MLR_MAIN=/home/dip/bin/mlr_main NB_THREADS=2 GLOG_logtostderr=true GLOG_v=-1 GLOG_minloglevel=0
