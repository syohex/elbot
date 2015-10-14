#
# Dockerfile for elbot
#

FROM ubuntu:15.04
MAINTAINER Syohei YOSHIDA <syohex@gmail.com> (@syohex)

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      git curl python-software-properties software-properties-common

RUN add-apt-repository -y ppa:ubuntu-elisp/ppa
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      emacs-snapshot-el emacs-snapshot-nox
    
RUN mkdir -p /usr/local/node && \
    curl -sSL https://nodejs.org/dist/v4.2.1/node-v4.2.1-linux-x64.tar.gz | \
      tar -v -C /usr/local/node -zx --strip-components=1
ENV PATH /usr/local/node/bin:$PATH

RUN git clone https://github.com/syohex/elbot /usr/local/elbot && \
    cd /usr/local/elbot && npm install

WORKDIR /usr/local/elbot
ENTRYPOINT ["./bin/hubot", "--adapter", "slack"] 
