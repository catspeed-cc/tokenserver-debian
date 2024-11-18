# Dockerfile for tokengenerator-alpine - due to technical reasons, only works with catspeed fork!

# based on debian:latest
FROM debian:latest
MAINTAINER mooleshacat / catspeed <admin@catspeed.cc>

# switch user to root or some commands will fail
USER root

# only use the build arg for local development:
ARG ROOTPASSWORD

# copy use_secret.sh
COPY ./etc/use_secret.sh /scripts/use_secret.sh

# chmod as executable
RUN chmod +x ./scripts/use_secret.sh

# mount the secret to /run/secrets:
RUN --mount=type=secret,id=rootpassword ./scripts/use_secret.sh

# disable installation of suggested / recommended packages
RUN echo 'APT::Install-Suggests "0";' >> /etc/apt/apt.conf.d/00-docker
RUN echo 'APT::Install-Recommends "0";' >> /etc/apt/apt.conf.d/00-docker

# copy debian.sources
COPY ./etc/apt/sources.list.d/debian.sources /etc/apt/sources.list.d/debian.sources

# copy sshd_config
COPY ./etc/ssh/sshd_config /etc/ssh/sshd_config

# chown redis folder
RUN chown -R redis: /var/lib/redis/

# upgrade & install dependencies
RUN DEBIAN_FRONTEND=noninteractive \
  apt-get update \
  && apt-get upgrade -y \
  && apt-get dist-upgrade -y \
  && apt-get install -y htop nano git wget curl cpulimit bash net-tools nginx redis-server openssh-server redis-tools nodejs npm postgresql-client \
  && rm -rf /var/lib/apt/lists/*

# copy the secret sauce scripts
COPY ./scripts/ /scripts/

# change work directory to /scripts/
WORKDIR /scripts/

# make the scripts executable
RUN chmod +x *.sh

# test node
RUN echo $(node -v)

# git the token generator (using YunzheZJU until iv-org makes significant code changes, then will consider switch)
RUN git -c http.sslVerify=false clone https://github.com/YunzheZJU/youtube-po-token-generator.git

# change directory to /scripts/youtube-po-token-generator/
WORKDIR /scripts/youtube-po-token-generator/

# install the token generator dependencies
RUN echo $(npm install)

# test the token generator
RUN echo $(node examples/one-shot.js)

# change work directory to /scripts/
WORKDIR /scripts/

# command to run on container start (entrypoint.sh bash script)
CMD /scripts/entrypoint.sh
