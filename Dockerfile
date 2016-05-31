#
# Dockerfile for elbot
#

FROM ubuntu:16.04
MAINTAINER Syohei YOSHIDA <syohex@gmail.com> (@syohex)

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      git curl python-software-properties software-properties-common \
      nodejs npm

RUN add-apt-repository -y ppa:ubuntu-elisp/ppa
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      emacs-snapshot-el emacs-snapshot-nox
    
RUN git clone https://github.com/syohex/elbot /usr/local/elbot && \
    cd /usr/local/elbot && npm install

WORKDIR /usr/local/elbot
CMD ["./bin/hubot", "--adapter", "slack" -n "elbot"]
