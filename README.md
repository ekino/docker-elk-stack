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

### Building images

*This step is optionnal as the images are publicly available on Docker registry*

First clone the repository and build the `base` image
```bash
git clone https://github.com/ekino/docker-elk-stack.git
cd docker-elk-stack
docker build -t ekino/base base
```

Then build the `ekino/logstash:elasticseach` image
```bash
j=""; for i in base java7 elasticsearch logstash; do docker build -t ekino/$i$j $i; j=":$i"; done
```

And the `ekino/kibana:base` image
```bash
j=""; for i in base kibana; do docker build -t ekino/$i$j $i; j=":$i"; done
```

### Running containers

Start the first container with `elasticsearch` and `logstash`
```bash
docker run --name elcontainer -d -p 9200:9200 -p 5000:5000 -e ELASTICSEARCH_AUTH=none ekino/logstash:elasticsearch
sleep 5 ; docker logs $(docker ps -lq)
```

And connect the second standalone container with `kibana`
```bash
docker run --link elcontainer:elcontainer -d -p 80:8080 -e ELASTICSEARCH_URL="http://elcontainer:9200" ekino/kibana:base
sleep 5 ; docker logs $(docker ps -lq)
```

Finally open up your browser at [localhost](http://localhost/)

**Important Note:**  
*The `elcontainer` url used in above ELASTICSEARCH_URL has to resolvable at 
host level ! The browser will try to access this url so you may need to update 
you `/etc/hosts` accordingly*