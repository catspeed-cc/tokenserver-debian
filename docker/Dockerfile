# Dockerfile for tokengenerator-alpine - due to technical reasons, only works with catspeed fork!

# based on debian:latest
FROM debian:latest
MAINTAINER mooleshacat / catspeed <admin@catspeed.cc>

# switch user to root or some commands will fail
USER root

# disable installation of suggested / recommended packages
RUN echo 'APT::Install-Suggests "0";' >> /etc/apt/apt.conf.d/00-docker
RUN echo 'APT::Install-Recommends "0";' >> /etc/apt/apt.conf.d/00-docker

# upgrade & install dependencies
RUN DEBIAN_FRONTEND=noninteractive \
  apt-get update \
  && apt-get upgrade -y \
  && apt-get dist-upgrade -y \
  && apt-get install -y htop nano git wget curl cpulimit bash nginx redis-server redis-tools nodejs npm postgresql-client \
  && rm -rf /var/lib/apt/lists/*

# disable nginx / redis, start manually later
#RUN /usr/bin/systemctl disable nginx
#RUN /usr/bin/systemctl disable redis-server

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
