# Dockerfile for tokengenerator-alpine - due to technical reasons, only works with catspeed fork!

FROM alpine:latest
MAINTAINER mooleshacat / catspeed <admin@catspeed.cc>

USER root

RUN apk update
RUN apk upgrade
RUN apk add htop nano git wget curl cpulimit bash redis

COPY ./scripts/ /scripts/

RUN chmod +x /scripts/*.sh
