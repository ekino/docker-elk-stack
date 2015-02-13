# --- ELASTICSEARCH ---

FROM ekino/java7:base
MAINTAINER Matthieu Fronton <fronton@ekino.com>

ENV DEBIAN_FRONTEND noninteractive
ENV ELASTICSEARCH_VERSION 1.3.8

# prerequisites
RUN apt-get update
RUN apt-get install -y curl supervisor

# install elasticsearch
RUN curl http://packages.elasticsearch.org/GPG-KEY-elasticsearch | apt-key add -
RUN echo 'deb http://packages.elasticsearch.org/elasticsearch/1.3/debian stable main' >> /etc/apt/sources.list.d/elasticsearch.list
RUN apt-get update
RUN apt-get install -y elasticsearch=${ELASTICSEARCH_VERSION}
RUN ln -s /etc/elasticsearch /usr/share/elasticsearch/config

# install nginx
RUN apt-get install -y nginx apache2-utils

# cleanup
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

# configure
ADD supervisord.conf /etc/supervisor/conf.d/elasticsearch.conf
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
ADD nginx_default /etc/nginx/sites-enabled/default

EXPOSE 9200

# startup
ADD elasticsearch.sh /start.d/10-elasticsearch
