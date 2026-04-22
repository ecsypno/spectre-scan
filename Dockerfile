# syntax=docker/dockerfile:1
FROM ubuntu:22.04

RUN groupadd -g 1234 spectre-group
RUN useradd -m -u 1234 -g spectre-group spectre

USER spectre
 
WORKDIR /home/spectre

RUN mkdir .scnr
RUN echo '#!/usr/bin/env bash' > ./setup.sh
RUN echo 'bash -c "$(curl -sSL https://get.ecsypno.com/scnr)" _ docker' >> ./setup.sh
RUN chmod +x ./setup.sh

USER root

RUN apt-get update
RUN apt-get install -y nano tzdata less curl libgconf-2-4 libatk1.0-0 libatk-bridge2.0-0 libgdk-pixbuf2.0-0 libgtk-3-0 \
  libgbm-dev libnss3-dev libxss-dev libasound2 tzdata

ENV TZ=Etc/UTC
RUN ln -fs /usr/share/zoneinfo/$TZ /etc/localtime && dpkg-reconfigure -f noninteractive tzdata

USER spectre
