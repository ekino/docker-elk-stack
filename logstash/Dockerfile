# --- LOGSTASH ---

FROM ekino/elasticsearch:oracle8
MAINTAINER Matthieu Fronton <fronton@ekino.com>

ENV DEBIAN_FRONTEND noninteractive
ENV LOGSTASH_VERSION 2.2.2

# prerequisites
RUN apt-get update && apt-get install -y openssl && mkdir -p /etc/logstash/ssl

# install logstash
WORKDIR /
RUN curl -o logstash.tar.gz https://download.elastic.co/logstash/logstash/logstash-${LOGSTASH_VERSION}.tar.gz
RUN mkdir -p /opt
RUN tar xzf logstash.tar.gz -C /opt
RUN ln -sf /opt/logstash-${LOGSTASH_VERSION} /opt/logstash
RUN rm -f logstash.tar.gz

# cleanup
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

# configure
ADD supervisord.conf /etc/supervisor/conf.d/logstash.conf
ADD lumberjack-input.conf /etc/logstash/conf.d/01-lumberjack-input.conf
ADD syslog.conf /etc/logstash/conf.d/10-syslog.conf
ADD lumberjack-output.conf /etc/logstash/conf.d/30-lumberjack-output.conf

EXPOSE 5000

# startup
ADD logstash.sh /start.d/15-logstash
