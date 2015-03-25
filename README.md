# Ekino Logging Stack

[![Circle CI](https://circleci.com/gh/ekino/docker-elk-stack.svg?style=svg)](https://circleci.com/gh/ekino/docker-elk-stack)

## Description

This repo helps you create a 2 nodes pool of docker containers to easily build
en ELK stack.

It's also the official image sources for :
* [`ekino/base`](https://registry.hub.docker.com/u/ekino/base/) > [`ekino/kibana`](https://registry.hub.docker.com/u/ekino/kibana/)
* [`ekino/base`](https://registry.hub.docker.com/u/ekino/base/) > [`ekino/java7`](https://registry.hub.docker.com/u/ekino/java7/) > [`ekino/elasticsearch`](https://registry.hub.docker.com/u/ekino/elasticsearch/) > [`ekino/logstash`](https://registry.hub.docker.com/u/ekino/logstash/)

## TL;DR

If you are on linux, simply execute this command :

```bash
curl -sSL https://raw.githubusercontent.com/ekino/docker-elk-stack/master/helper.sh | bash -s run
```

## Usage

Containers :

* 1st container : elasticsearch 1.5.0 + logstash 1.4.2
* 2nd container : logstash-forwarder
* 3rd container : kibana 4

### Running containers manually

#### ElasticSearch/Logstash

Start the first container with `elasticsearch` and `logstash`:
```bash
docker run --name es.local -d \
  -p 9200:9200 \
  -p 5000:5000 \
  -e CERTIFICATE_CN=logstash.endpoint.url
  ekino/logstash:elasticsearch

docker logs $(docker ps -lq)
```

It starts a container which will autogenerate the required SSL certificate for
logstash's [lumberjack input](http://logstash.net/docs/1.4.2/inputs/lumberjack).

For `CERTIFICATE_CN` you must specify the FQDN that will be used by *remote*
hosts to establish a secure SSL connection.

#### Logstash-Forwarder

Start the 2nd container `logstash-forwarder` with the shared secret SSL cert/key
```bash
# copy SSL secrets from container to host
docker cp es.local:/etc/logstash/ssl lumberjack-secrets

# start container with volumes to your custom config file + shared secrets
docker run --name forwarder.local -d \
  --link es.local:logstash.endpoint.url \
  -e LUMBERJACK_ENDPOINT=logstash.endpoint.url:5000 \
  -v $(readlink -f lumberjack-secrets/ssl):/etc/logstash/ssl \
  ekino/logstash-forwarder
```

It will send the first log entries to `logstash` and so init the elasticsearch
indexes. This will prevent the messy
[Unable to fetch mapping](https://github.com/elastic/kibana/issues/1950) error
message !

*Note: For real life use of the container, consider using custom log file
(`-v /path/to/your/config.json:/etc/logstash/config.json`) to read other
containers log files, accessible via container volumes...*

#### Kibana

Start the 3rd container `kibana` to connect the 1st one:
```bash
docker run --name kibana.local -d \
  --link es.local:elasticsearch.projectname.intra \
  -p 80:5601 \
  -e ELASTICSEARCH_URL="http://elasticsearch.projectname.intra:9200" \
  ekino/kibana:base
```

*Note: Since Kibana 4 request to `ELASTICSEARCH_URL` will be performed from the
server, not from the browser anymore, which will make things easier to manage
(elasticsearch doesn't have to be opened to internet anymore, etc...)*

Finally open up your browser at [localhost](http://localhost/)

### Running containers with docker-compose

TODO


