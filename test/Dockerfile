FROM ubuntu:19.10
RUN apt update && apt install -y make curl wget git vim
WORKDIR /build/
COPY . ./
RUN make docker-install
