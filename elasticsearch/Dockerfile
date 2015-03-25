# --- ELASTICSEARCH ---

FROM ekino/java7:base
MAINTAINER Matthieu Fronton <fronton@ekino.com>

ENV DEBIAN_FRONTEND noninteractive
ENV ELASTICSEARCH_VERSION 1.5.0

# install elasticsearch
RUN curl -o elasticsearch.tar.gz https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-${ELASTICSEARCH_VERSION}.tar.gz
RUN mkdir -p /opt
RUN tar xzf elasticsearch.tar.gz -C /opt
RUN ln -sf /opt/elasticsearch-${ELASTICSEARCH_VERSION} /opt/elasticsearch
RUN rm -f elasticsearch.tar.gz

# configure
ADD supervisord.conf /etc/supervisor/conf.d/elasticsearch.conf

EXPOSE 9200

# startup
ADD elasticsearch.sh /start.d/10-elasticsearch
