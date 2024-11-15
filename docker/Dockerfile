# Dockerfile for tokengenerator-alpine - due to technical reasons, only works with catspeed fork!

FROM alpine:latest
MAINTAINER mooleshacat / catspeed <admin@catspeed.cc>

USER root

RUN apk update
RUN apk upgrade
RUN apk add htop nano git wget curl cpulimit bash redis

COPY ./scripts/ /scripts/

RUN chmod +x /scripts/*.sh

ARG NODE_VERSION=18.16.0
ARG ALPINE_VERSION=3.17.2

FROM node:{ALPINE_VERSION}

COPY --from=node /usr/lib /usr/lib
COPY --from=node /usr/local/lib /usr/local/lib
COPY --from=node /usr/local/include /usr/local/include
COPY --from=node /usr/local/bin /usr/local/bin

RUN node -v

CMD /scripts/entrypoint.sh
