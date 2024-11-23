# Dockerfile for tokengenerator-alpine - due to technical reasons, only works with catspeed fork!

# based on debian:latest
FROM debian:latest
MAINTAINER mooleshacat / catspeed <admin@catspeed.cc>

# switch user to root or some commands will fail
USER root

# disable installation of suggested / recommended packages
RUN echo 'APT::Install-Suggests "0";' >> /etc/apt/apt.conf.d/00-docker
RUN echo 'APT::Install-Recommends "0";' >> /etc/apt/apt.conf.d/00-docker

# copy debian.sources
COPY ./tokenserver-data/etc/apt/sources.list.d/debian.sources /etc/apt/sources.list.d/debian.sources

# copy sshd_config
COPY ./tokenserver-data/etc/ssh/sshd_config /etc/ssh/sshd_config

# upgrade & install dependencies
RUN DEBIAN_FRONTEND=noninteractive \
  apt-get update \
  && apt-get upgrade -y \
  && apt-get dist-upgrade -y \
  && apt-get install -y htop nano git wget curl cpulimit bash net-tools nginx php8.2-fpm php8.2-redis redis-server openssh-server redis-tools nodejs npm postgresql-client

# chown redis folder
RUN chown -R redis:redis /var/lib/redis/

# copy the secret sauce scripts
COPY ./scripts/ /scripts/

# change work directory to /scripts/
WORKDIR /scripts/

# make the scripts executable
RUN chmod +x *.sh

# test node
RUN echo $(node -v)

# change work directory to /scripts/
WORKDIR /scripts/

# command to run on container start (entrypoint.sh bash script)
CMD /scripts/entrypoint.sh
