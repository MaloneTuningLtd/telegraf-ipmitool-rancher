FROM pockost/telegraf-rancher

# build & install ipmitool
# thanks to https://github.com/urzds/ipmitool-docker

ARG IPMITOOL_VER=v1.8.16-4.4

RUN apk add --no-cache --virtual build-dependencies \
  linux-headers \
  openssl-dev \
  curl \
  file \
  gcc \
  libgcc \
  libc-dev \
  make \
  libtool \
  rsync \
  unzip \
  wget \
&& mkdir /tmp/impitool && mkdir /tmp/install && cd /tmp/impitool \
&& wget -qO- https://github.com/urzds/ipmitool-docker/archive/${IPMITOOL_VER}.tar.gz | tar xz --strip 1 \
&& cd build \
&& ROOT=/export D=/tmp/install SCRIPTDIR=/ AUXDIR=/aux WORKDIR=/tmp SOURCEDIR=/tmp ./pkg.sh build ipmitool-1.8.16 \
&& mv /tmp/install/usr/bin/ipmitool /usr/bin/ipmitool \
&& rm -rf /tmp/* \
&& apk del build-dependencies

RUN apk add --no-cache libcrypto1.0

COPY telegraf.conf /etc/telegraf/telegraf.conf

