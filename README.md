Petuum v1.1
===========

To install Petuum, please refer to the Petuum [documentation](http://docs.petuum.com/).

Website: http://petuum.org

For support, or to report bugs, please send email to petuum-user@googlegroups.com. Please provide your name and affiliation when requesting support; we do not support anonymous inquiries.

Overview
========

Petuum is a distributed machine learning framework. It takes care of the difficult system "plumbing work", allowing you to focus on the ML. Petuum runs efficiently at scale on research clusters and cloud compute like Amazon EC2 and Google GCE.

Petuum provides essential distributed programming tools to tackle the challenges of running ML at scale: Big Data (many data samples) and Big Models (very large parameter and intermediate variable spaces). Unlike general-purpose distributed programming platforms, Petuum is designed specifically for ML algorithms. This means that Petuum takes advantage of data correlation, staleness, and other statistical properties to maximize the performance for ML algorithms, realized through core features such as Bösen, a bounded-asynchronous key-value store, and Strads, a scheduler for iterative ML computations.

In addition to distributed ML programming tools, Petuum comes with many distributed ML algorithms, all implemented on top of the Petuum framework for speed and scalability. Please refer to the Petuum [documentation](http://docs.petuum.com/) for a full listing.

Petuum comes from "perpetuum mobile," which is a musical style characterized by a continuous steady stream of notes. Paganini's Moto Perpetuo is an excellent example. It is our goal to build a system that runs efficiently and reliably -- in perpetual motion.


CMake Build
=========

First install necessary libraries on the system:
```
sudo apt-get -y install libgoogle-glog-dev libzmq3-dev libyaml-cpp-dev \
  libgoogle-perftools-dev libsnappy-dev libsparsehash-dev libgflags-dev \
  libboost-system1.55-dev libboost-thread1.55-dev libleveldb-dev libconfig++-dev \
  libghc-hashtables-dev libtcmalloc-minimal4 libevent-pthreads-2.0-5 libeigen3-dev
```
Then do the following to compile the project:
```
mkdir build
cd build && cmake ..
make -j
```
