FROM ubuntu:disco
LABEL maintainer="nickgerace"
WORKDIR /app
COPY . /app
RUN apt update -y \
    && apt install -y git make \
    && make setup-ubuntu
