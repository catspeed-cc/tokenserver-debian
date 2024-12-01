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
COPY ./etc/apt/sources.list.d/debian.sources /etc/apt/sources.list.d/debian.sources

# copy sshd_config
COPY ./etc/ssh/sshd_config /etc/ssh/sshd_config

# upgrade & install dependencies
RUN DEBIAN_FRONTEND=noninteractive \
  apt update ; \
  apt upgrade -y ; \
  apt dist-upgrade -y ; \
  apt install -y htop nano git wget curl cpulimit net-tools nginx php8.2-fpm php8.2-redis \
  redis-server openssh-server redis-tools nodejs npm postgresql-client python3 python3-full \
  python3-virtualenv python3-pip ;

# chown redis folder
RUN chown -R redis:redis /var/lib/redis/

# copy the submodules
COPY ./submodules/ /submodules/

# copy the secret sauce scripts
COPY ./scripts/ /scripts/

# copy the /var/www/html directory
COPY ./var/www/html/ /var/www/html/

# copy the /etc/redis/redis.conf file
COPY ./etc/redis/redis.conf /etc/redis/redis.conf

# copy the /etc/nginx/nginx.conf file
COPY ./etc/nginx/nginx.conf /etc/nginx/nginx.conf

# copy the /etc/nginx/sites-available/default file
COPY ./etc/nginx/sites-available/default /etc/nginx/sites-available/default

# copy the /etc/php/8.2/fpm/php.ini file
COPY ./etc/php/8.2/fpm/php.ini /etc/php/8.2/fpm/php.ini

# copy the /etc/php/8.2/fpm/pool.d/www.conf file
COPY ./etc/php/8.2/fpm/pool.d/www.conf /etc/php/8.2/fpm/pool.d/www.conf

# change work directory to /scripts/
WORKDIR /scripts/

# make the scripts executable
RUN chmod +x /scripts/*.sh

# chown the scripts directory to git:git
RUN chown root:root /scripts/

# test node
RUN echo $(node -v)

# change work directory to /scripts/
WORKDIR /scripts/

# command to run on container start (entrypoint.sh bash script)
CMD /scripts/entrypoint.sh
