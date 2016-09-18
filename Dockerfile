FROM ubuntu:16.04
MAINTAINER Dobashi, Hiroki <exlair@gmail.com>

# RUN sed -i -e 's/archive.ubuntu.com\/ubuntu\//ftp.jaist.ac.jp\/pub\/Linux\/ubuntu\//' /etc/apt/sources.list

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get -y upgrade \
  && apt-get install -y wget openjdk-8-jre dcraw mediainfo ffmpeg mencoder mplayer vlc \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

ENV ENTRYKIT_VERSION=0.4.0
RUN wget https://github.com/progrium/entrykit/releases/download/v${ENTRYKIT_VERSION}/entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz \
  && tar -xvzf entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz \
  && rm entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz \
  && mv entrykit /bin/entrykit \
  && chmod +x /bin/entrykit \
  && entrykit --symlink

ENV UMS_VER=6.5.0

ENV UMS_TARNAME=UMS-${UMS_VER}-Java8.tgz \
    UMS_DLURL=https://sourceforge.net/projects/unimediaserver/files/Official%20Releases/Linux/UMS-${UMS_VER}-Java8.tgz/download \
    UMS_PROFILE=/srv/ums/UMS.conf

RUN wget ${UMS_DLURL} -O /srv/UMS-${UMS_VER}-Java8.tgz &&\
  cd /srv &&\
  tar zxf UMS-${UMS_VER}-Java8.tgz &&\
  rm UMS-${UMS_VER}-Java8.tgz &&\
  mv ums-${UMS_VER} ums &&\
  cd /srv/ums &&\
  mkdir conf &&\
  rm UMS.conf &&\
  mv WEB.conf conf &&\
  ln -s conf/UMS.conf UMS.conf &&\
  ln -s conf/WEB.conf WEB.conf &&\
  groupadd -g 500 ums &&\
  useradd -u 500 -g 500 -d /srv/ums -c UniversalMediaServer -s /bin/bash -M ums &&\
  chown -R ums:ums /srv/ums

ADD ./assets/UMS.conf.tmpl /srv/ums/conf/UMS.conf.tmpl
RUN chown ums:ums /srv/ums/conf/UMS.conf.tmpl

USER ums
WORKDIR /srv/ums

EXPOSE 5001 9001
ENTRYPOINT [ \
  "switch", \
    "shell=/bin/sh", \
    "version=echo ${UMS_VER}", "--", \
  "render", "/srv/ums/conf/UMS.conf",  "--", \
  "/srv/ums/UMS.sh" ]

