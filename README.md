# Ekino Logging Stack

## Description

This repo helps you create a 2 nodes pool of docker containers to easily build
en ELK stack.

It's also the official image sources for :
* [`ekino/base`](https://registry.hub.docker.com/u/ekino/base/)
 * [`ekino/kibana`](https://registry.hub.docker.com/u/ekino/kibana/)
 * [`ekino/java7`](https://registry.hub.docker.com/u/ekino/java7/)
  * [`ekino/elasticsearch`](https://registry.hub.docker.com/u/ekino/elasticsearch/)
   * [`ekino/logstash`](https://registry.hub.docker.com/u/ekino/logstash/)

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
docker build -t ekino/java7:base java7
docker build -t ekino/elasticsearch:java7 elasticsearch
docker build -t ekino/logstash:elasticsearch logstash
```

And the `ekino/kibana:base` image
```bash
docker build -t ekino/kibana:base kibana
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