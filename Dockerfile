FROM ubuntu:17.10

MAINTAINER Aderbal Machado Ribeiro "https://github.com/aderbal/buildozer"

# Update ubuntu:
RUN set -x \
    && apt-get update -qq \
    && apt-get -y full-upgrade \
    && apt-get autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# install needed packages for buildozer
RUN set -x \
    && dpkg --add-architecture i386 \
    && apt-get update -qq \
    && apt-get -y install lib32stdc++6 lib32z1 lib32ncurses5 build-essential python-pip unzip curl nano \
    && apt-get -y install git openjdk-8-jdk --no-install-recommends zlib1g-dev \
    && apt-get autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# The buildozer VM used Cython v0.25 and buildozer v0.32
RUN set -x \
    && python -m pip install --upgrade pip \
    && python -m pip install "cython<0.26" \
    && python -m pip install "buildozer!=0.33" \
    && python -m pip install python-for-android \
    && python -m pip install pyOpenssl

# adjuste user buildozer
RUN set -x \
    && mkdir /buildozer \
    && adduser buildozer --disabled-password --disabled-login \
    && chown -R buildozer:buildozer /buildozer/

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
