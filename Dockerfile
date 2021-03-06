FROM ubuntu:17.10

MAINTAINER Aderbal Machado Ribeiro "https://github.com/aderbal/buildozer"

ARG DEBIAN_FRONTEND=noninteractive

# install needed packages for buildozer
RUN set -x \
    && apt-get update \
    && dpkg --add-architecture i386 \
    && apt-get install -y --no-install-recommends apt-utils \
    && apt-get -y install build-essential lib32stdc++6 lib32z1 lib32ncurses5 python-pip unzip curl \
    && apt-get -y install git openjdk-8-jdk --no-install-recommends zlib1g-dev libzbar-dev dh-autoreconf \
    && apt-get -y install mlocate nano sudo \
    && apt-get autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# The buildozer VM used Cython v0.25 and buildozer v0.32
RUN set -x \
    && python -m pip install --upgrade pip \
    && python -m pip install ipython \
    && python -m pip install "cython<0.26" \
    && python -m pip install "buildozer!=0.33" \
    && python -m pip install requests \
    && python -m pip install kivy-garden \
    && python -m pip install python-for-android \
    && python -m pip install pyOpenssl \
    && python -m pip install pillow \
    && python -m pip install "zbarlight==1.2"

# zBarCam
RUN set -x \
    && garden install xcamera \
    && garden install zbarcam

# Upgrade ubuntu:
RUN set -x \
    && apt-get -y upgrade \
    && apt-get autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# adjuste user buildozer
RUN set -x \
    && mkdir /buildozer \
    && adduser buildozer --disabled-password --disabled-login \
    && chown -R buildozer:buildozer /buildozer/ \
    && echo "buildozer:kivy" | chpasswd

# patch sudoers.diff
COPY sudoers.diff /sudoers.diff

RUN set -x \
    && patch /etc/sudoers < /sudoers.diff \
    && rm -f /sudoers.diff \
    && echo "root:kivy" | chpasswd

# patch android.diff
COPY android.diff /android.diff

RUN set -x \
    && patch /usr/local/lib/python2.7/dist-packages/buildozer/targets/android.py < /android.diff \
    && rm -f /android.diff

# patch .buildozer
COPY home.buildozer.tar.gz /home.buildozer.tar.gz

RUN set -x \
    && tar -zxf /home.buildozer.tar.gz \
    && rm -f /home.buildozer.tar.gz

USER buildozer

VOLUME /buildozer/

WORKDIR /buildozer/
