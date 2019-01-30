# -*- mode: indented-text -*-

FROM resin/rpi-raspbian:stretch

LABEL maintainer="BERNHARD Raphael <raphael.bernhard@orange.com>"

ENV http_proxy=${http_proxy}
ENV https_proxy=${https_proxy}

COPY tmp_root /

RUN test -z "$skip_apt" \
    && apt-get update \
    && apt-get -y \
       	    apt-utils \
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
	    libboost-thread1.62.0 \
     &&	apt-get clean \
     && rm -rf /tmp/* \
     && rm -f /core


#ENTRYPOINT ["/build.sh"]




#!! linux-vdso.so.1 (0x7edea000)
#!! librt.so.1 => /lib/arm-linux-gnueabihf/librt.so.1 (0x76f97000)
#!! libnsl.so.1 => /lib/arm-linux-gnueabihf/libnsl.so.1 (0x76f73000)
#!! libboost_thread.so.1.62.0 => not found
#!! libboost_system.so.1.62.0 => not found
#!! libsnappy.so.1 => not found
#!! libyaml-cpp.so.0.5 => not found
#!! libleveldb.so.1 => not found
#!! libstdc++.so.6 => /usr/lib/arm-linux-gnueabihf/libstdc++.so.6 (0x76e2b000)
#!! libm.so.6 => /lib/arm-linux-gnueabihf/libm.so.6 (0x76dac000)
#!! libgcc_s.so.1 => /lib/arm-linux-gnueabihf/libgcc_s.so.1 (0x76d7f000)
#!! libpthread.so.0 => /lib/arm-linux-gnueabihf/libpthread.so.0 (0x76d56000)
#!! libc.so.6 => /lib/arm-linux-gnueabihf/libc.so.6 (0x76c17000)
#!! /lib/ld-linux-armhf.so.3 (0x76fae000)
