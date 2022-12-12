ARG NODE_VERSION

FROM node:${NODE_VERSION}-buster-slim

SHELL ["/bin/bash", "-l", "-c"]

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    libcurl4-gnutls-dev libexpat1-dev gettext libz-dev libssl-dev autoconf \
    ca-certificates \
    wget && \
    rm -rf /var/lib/apt/lists/* \
    && wget -O sass-embedded.tar.gz https://github.com/sass/dart-sass-embedded/releases/download/$1.56.1/sass_embedded-$1.56.1-linux-x64.tar.gz\
    && tar xf sass-embedded.tar.gz\
    && mv ./sass_embedded/dart-sass-embedded /usr/bin/ ;\
    chmod 755 /usr/bin/dart-sass-embedded &&\
    rm -rf sass-embedded.tar.gz ;

WORKDIR /git
ENV GIT_VERSION="2.28.0"
RUN wget -q "https://github.com/git/git/archive/v${GIT_VERSION}.tar.gz" && \
    tar -zxf "./v${GIT_VERSION}.tar.gz" && \
    rm "./v${GIT_VERSION}.tar.gz" && \
    cd "./git-${GIT_VERSION}" && \
    make configure && \
    ./configure --prefix=/usr && \
    make all && \
    make install

WORKDIR /repo
ENV RUNNER_TEMP="/tmp"

CMD [ "bash" ]
