# Dockerfile for tokengenerator-alpine - due to technical reasons, only works with catspeed fork!

FROM alpine:latest
MAINTAINER mooleshacat / catspeed <admin@catspeed.cc>

FROM node:current-alpine AS node

USER root

RUN apk update
RUN apk upgrade
RUN apk add htop nano git wget curl cpulimit bash redis
RUN apk add libc6-compat gcompat

COPY ./scripts/ /scripts/

RUN chmod +x /scripts/*.sh

# install node?
COPY --from=node /usr/lib /usr/lib
COPY --from=node /usr/local/lib /usr/local/lib
COPY --from=node /usr/local/include /usr/local/include
COPY --from=node /usr/local/bin /usr/local/bin

RUN echo $(node -v)

WORKDIR /scripts/youtube-po-token-generator/

RUN echo $(npm install)

WORKDIR /scripts/

CMD /scripts/entrypoint.sh
