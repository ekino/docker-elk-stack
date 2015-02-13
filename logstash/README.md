# ekino/logstash

## Description

Part of ekino's `docker-elk-stack`
Check out the [project page](https://github.com/ekino/docker-elk-stack)

## Basic usage

```bash
docker build -t ekino/logstash:elasticsearch .
# default http auth : admin/changeme
docker run -d -p 9200:9200 -p 5000:5000 ekino/logstash:elasticsearch
# custom http auth
docker run -d -p 9200:9200 -p 5000:5000 -e ELASTICSEARCH_USER=ekino -e ELASTICSEARCH_PASS=s4mpl3Pass ekino/logstash:elasticsearch
# no http auth
docker run -d -p 9200:9200 -p 5000:5000 -e ELASTICSEARCH_AUTH=none ekino/logstash:elasticsearch
```