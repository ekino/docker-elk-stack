# --- ELASTICSEARCH ---

FROM ekino/java:oracle8
MAINTAINER Matthieu Fronton <fronton@ekino.com>

ENV DEBIAN_FRONTEND noninteractive
ENV ELASTICSEARCH_VERSION 2.2.0

# install elasticsearch
RUN curl -o elasticsearch.tar.gz https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-${ELASTICSEARCH_VERSION}.tar.gz
RUN curl -o elasticsearch.tar.gz https://download.elasticsearch.org/elasticsearch/release/org/elasticsearch/distribution/tar/elasticsearch/$ELASTICSEARCH_VERSION/elasticsearch-$ELASTICSEARCH_VERSION.tar.gz
RUN mkdir -p /opt
RUN tar xzf elasticsearch.tar.gz -C /opt
RUN ln -sf /opt/elasticsearch-${ELASTICSEARCH_VERSION} /opt/elasticsearch
RUN rm -f elasticsearch.tar.gz

# configure
ADD supervisord.conf /etc/supervisor/conf.d/elasticsearch.conf

EXPOSE 9200 9300

# startup
ADD elasticsearch.sh /start.d/10-elasticsearch
