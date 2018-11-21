FROM alpine:3.8

# aircrack-ng & airmon-ng
# deps = aircrack-ng
# add reaver
# deps = build-base, libpcap-dev, aircrack-ng
RUN apk add --no-cache \
      aircrack-ng \
      build-base \
      libpcap-dev \
 && rm -rf /var/cache/apk/*

RUN wget https://github.com/wiire/pixiewps/archive/master.zip \
 && unzip master.zip \
 && rm master.zip \
 && cd pixiewps-master/ \
 && make \
 && make install \
 && cd .. \
 && wget https://github.com/t6x/reaver-wps-fork-t6x/archive/master.zip \
 && unzip master.zip \
 && rm master.zip \
 && cd reaver-wps-fork-t6x-master/src \
 && ./configure \
 && make \
 && make install
