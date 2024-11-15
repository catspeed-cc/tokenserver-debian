# Dockerfile for tokengenerator-alpine - due to technical reasons, only works with catspeed fork!

FROM debian:latest
MAINTAINER mooleshacat / catspeed <admin@catspeed.cc>

USER root

RUN echo 'APT::Install-Suggests "0";' >> /etc/apt/apt.conf.d/00-docker
RUN echo 'APT::Install-Recommends "0";' >> /etc/apt/apt.conf.d/00-docker

RUN DEBIAN_FRONTEND=noninteractive \
  apt-get update \
  && apt-get upgrade -y \
  && apt-get dist-upgrade -y \
  && apt-get install -y htop nano git wget curl cpulimit bash redis-tools nodejs npm \
  && rm -rf /var/lib/apt/lists/*

COPY ./scripts/ /scripts/

WORKDIR /scripts/

RUN chmod +x *.sh

RUN echo $(node -v)

RUN git -c http.sslVerify=false clone https://github.com/YunzheZJU/youtube-po-token-generator.git

WORKDIR /scripts/youtube-po-token-generator/

RUN echo $(npm install)

RUN echo $(node examples/one-shot.js)

WORKDIR /scripts/

CMD /scripts/entrypoint.sh
