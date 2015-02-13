# ekino/kibana

## Description

Ekino's kibana container to be used with ekino/elasticsearch

## Usage (standalone)

```bash
docker build -t ekino/kibana:base .
# start kibana on port 80 (suppose elasticsearch accessible on localhost:9200)
docker run -d -p 80:8080 ekino/kibana:base
# start kibana on port 80 and provide remote elasticsearch url
docker run -d -p 80:8080 -e ELASTICSEARCH_URL="http://remotehost:9200" ekino/kibana:base
```

*Note: The `remotehost` url has to be resolved by the frontend, so if working local you should consider updating your /etc/hosts file*

## Advanced Usage (with Elasticsearch+Logstash container)

```bash
docker run --name elcontainer -d -p 9200:9200 -p 5000:5000 -e ELASTICSEARCH_AUTH=none ekino/logstash:elasticsearch
docker run --link elcontainer:elcontainer -d -p 80:8080 -e ELASTICSEARCH_URL="http://elcontainer:9200" ekino/kibana:base
```

