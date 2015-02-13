# --- BASE ---

FROM ubuntu:trusty
MAINTAINER Matthieu Fronton <fronton@ekino.com>

ENV DEBIAN_FRONTEND noninteractive
ENV TERM xterm

# prerequisites
RUN apt-get update
RUN apt-get install -y curl supervisor vim tcpdump

# cleanup
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

# configure
ADD supervisord.conf /etc/supervisor/conf.d/base.conf

# startup
RUN mkdir -p /start.d
ADD ascii.sh /start.d/00-ekino
ADD supervisord.sh /start.d/99-supervisord

ADD start.sh /start.sh
CMD ["/start.sh"]
