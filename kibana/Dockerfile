# --- KIBANA ---

FROM ekino/base
MAINTAINER Matthieu Fronton <fronton@ekino.com>

ENV DEBIAN_FRONTEND noninteractive
ENV KIBANA_VERSION 4.0.1

# install kibana
RUN curl -o kibana.tar.gz https://download.elasticsearch.org/kibana/kibana/kibana-${KIBANA_VERSION}-linux-x64.tar.gz
RUN mkdir -p /opt
RUN tar xzf kibana.tar.gz -C /opt
RUN ln -sf /opt/kibana-${KIBANA_VERSION}-linux-x64 /opt/kibana
RUN rm -f kibana.tar.gz

# cleanup
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

# configure
ADD supervisord.conf /etc/supervisor/conf.d/kibana.conf
#RUN cp /opt/kibana/app/dashboards/logstash.json /opt/kibana/app/dashboards/default.json

EXPOSE 5601

# startup
ADD kibana.sh /start.d/05-kibana
