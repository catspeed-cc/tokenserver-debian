# Dockerfile for tokengenerator-alpine - due to technical reasons, only works with catspeed fork!

FROM alpine:latest
MAINTAINER mooleshacat / catspeed <admin@catspeed.cc>

RUN apk update
RUN apk upgrade
RUN apk add htop nano git wget curl cpulimit timeout

COPY ./scripts/ /scripts/

