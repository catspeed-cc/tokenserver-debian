# Dockerfile for tokengenerator-alpine - due to technical reasons, only works with catspeed fork!

FROM alpine:latest
MAINTAINER mooleshacat / catspeed <admin@catspeed.cc>

USER root

RUN apk update
RUN apk upgrade
RUN apk add htop nano git wget curl cpulimit bash redis

COPY ./scripts/ /scripts/

RUN chmod +x /scripts/*.sh

ENV NVM_DIR /usr/local/nvm # or ~/.nvm 

ENV NODE_VERSION v22.11.0

# Install nvm with node and npm
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.1/install.sh | bash; \
    && . $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

CMD /scripts/entrypoint.sh
