# --- LOGSTASH ---

FROM ekino/elasticsearch:java7
MAINTAINER Matthieu Fronton <fronton@ekino.com>

ENV DEBIAN_FRONTEND noninteractive
ENV LOGSTASH_VERSION_MAJOR 1.4
ENV LOGSTASH_VERSION_FULL 1.4.2-1-2c0f5a1

# prerequisites
WORKDIR /etc/pki/tls
RUN apt-get update
RUN apt-get install -y openssl
RUN mkdir private certs
RUN openssl req -x509 -batch -nodes -days 3650 -newkey rsa:2048 -keyout private/logstash-forwarder.key -out certs/logstash-forwarder.crt

# install logstash
WORKDIR /
RUN echo "deb http://packages.elasticsearch.org/logstash/${LOGSTASH_VERSION_MAJOR}/debian stable main" >> /etc/apt/sources.list.d/logstash.list
RUN apt-get update && apt-get install logstash=${LOGSTASH_VERSION_FULL}
RUN mkdir -p /etc/pki/tls/certs /etc/pki/tls/private

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
