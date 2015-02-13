# --- KIBANA ---

FROM ekino/base
MAINTAINER Matthieu Fronton <fronton@ekino.com>

ENV DEBIAN_FRONTEND noninteractive
ENV KIBANA_VERSION 3.1.0

# required tools
RUN apt-get update
RUN apt-get install -y python-twisted

# install kibana
RUN curl -o kibana.tar.gz https://download.elasticsearch.org/kibana/kibana/kibana-${KIBANA_VERSION}.tar.gz
RUN mkdir -p /opt
RUN tar xzf kibana.tar.gz -C /opt
RUN ln -sf /opt/kibana-${KIBANA_VERSION} /opt/kibana
RUN rm -f kibana.tar.gz
RUN apt-get -y install curl

# cleanup
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

# configure
ADD supervisord.conf /etc/supervisor/conf.d/kibana.conf
RUN cp /opt/kibana/app/dashboards/logstash.json /opt/kibana/app/dashboards/default.json

EXPOSE 8080

# startup
ADD kibana.sh /start.d/05-kibana
