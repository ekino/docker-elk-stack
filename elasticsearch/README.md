# ekino/elasticsearch

## Description

Part of ekino's `docker-elk-stack`
Check out the [project page](https://github.com/ekino/docker-elk-stack)

## Basic usage

```bash
docker build -t ekino/elasticsearch:java7 .
# default http auth : admin/changeme
docker run -d -p 9200:9200 ekino/elasticsearch:java7
# custom http auth
docker run -d -p 9200:9200 -e ELASTICSEARCH_USER=ekino -e ELASTICSEARCH_PASS=s4mpl3Pass ekino/elasticsearch:java7
# no http auth
docker run -d -p 9200:9200 -e ELASTICSEARCH_AUTH=none ekino/elasticsearch:java7
```