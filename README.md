# Ekino Logging Stack

[![Circle CI](https://circleci.com/gh/ekino/docker-elk-stack.svg?style=svg)](https://circleci.com/gh/ekino/docker-elk-stack)

## Description

This repo helps you create a 2 nodes pool of docker containers to easily build
en ELK stack.

It's also the official image sources for :
* [`ekino/kibana`](https://registry.hub.docker.com/u/ekino/kibana/)
* [`ekino/java7`](https://registry.hub.docker.com/u/ekino/java7/) > [`ekino/elasticsearch`](https://registry.hub.docker.com/u/ekino/elasticsearch/) > [`ekino/logstash`](https://registry.hub.docker.com/u/ekino/logstash/)

## TL;DR

If you are on linux, simply execute this command :

```bash
curl -sSL https://raw.githubusercontent.com/ekino/docker-elk-stack/master/helper.sh | bash -s run
```

## Usage

### Running containers with docker-compose

If you have [`docker-compose`](https://github.com/docker/compose) (formerly `fig`)

```bash
docker-compose up -d
```

### Running containers manually

#### ElasticSearch/Logstash

Start the 1st container with `elasticsearch` and `logstash`:
```bash
docker run --name eslogstash -d \
  -p 9200:9200 \
  -p 5000:5000 \
  -e CERTIFICATE_CN=logstash.example.com
  ekino/logstash:elasticsearch
```

It starts a container which will autogenerate the required SSL certificate for
logstash's [lumberjack input](http://logstash.net/docs/1.4.2/inputs/lumberjack).

For `CERTIFICATE_CN` you must specify the FQDN that will be used by *remote*
hosts to establish a secure SSL connection.

#### Logstash-Forwarder

Start the 2nd container `logstash-forwarder` with the shared secret SSL cert/key
```bash
# copy SSL secrets from container to host
docker cp eslogstash:/etc/logstash/ssl lumberjack-secrets

# start container with volumes to your custom config file + shared secrets
docker run --name forwarder -d \
  --link eslogstash:logstash.example.com \
  -e LUMBERJACK_ENDPOINT=logstash.example.com:5000 \
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
docker run --name kibana -d \
  --link eslogstash:elasticsearch.example.com \
  -p 80:5601 \
  -e ELASTICSEARCH_URL="http://elasticsearch.example.com:9200" \
  ekino/kibana:base
```

*Note: Since Kibana 4 request to `ELASTICSEARCH_URL` will be performed from the
server, not from the browser anymore, which will make things easier to manage
(elasticsearch doesn't have to be opened to internet anymore, etc...)*

Finally open up your browser at [localhost](http://localhost/)

## Further Reading

The `TL;DR` and `docker-compose` spin up 3 docker container running on the same
host, so they use a shared data container volume between
`elasticsearch/logstash` and `logstash-forwarder`.

The manual version uses `docker cp` to extract the ssl folder so it can be
distributed if containers are not runned on the same host.
