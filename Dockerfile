FROM alpine:3.8

# reaver build deps = build-base, libpcap-dev
RUN apk add --no-cache --virtual .build-deps \
      build-base \
      libpcap-dev \
 # add aircrack-ng and airmon-ng
 && apk add --no-cache \
      aircrack-ng \
 # download and install pixiewps from source (reaver dependency)
 && wget -O pixiewps.zip https://github.com/wiire/pixiewps/archive/master.zip \
 && unzip pixiewps.zip \
 && rm pixiewps.zip \
 && cd pixiewps-master/ \
 && make \
 && make install \
 && cd .. \
 && rm -rf pixiewps-master \
 # download and install reaver from source
 && wget -O reaver.zip https://github.com/t6x/reaver-wps-fork-t6x/archive/master.zip \
 && unzip reaver.zip \
 && rm reaver.zip \
 && cd reaver-wps-fork-t6x-master/src \
 && ./configure \
 && make \
 && make install \
 && cd .. \
 && rm -rf reaver-wps-fork-t6x-master \
 # clean up build dependencies
 && apk del --purge .build-deps
