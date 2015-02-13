# ekino/kibana

## Description

Part of ekino's `docker-elk-stack`
Check out the [project page](https://github.com/ekino/docker-elk-stack)

## Basic usage (standalone)

```bash
docker build -t ekino/kibana:base .
# start kibana on port 80 (suppose elasticsearch accessible on localhost:9200)
docker run -d -p 80:8080 ekino/kibana:base
# start kibana on port 80 and provide remote elasticsearch url
docker run -d -p 80:8080 -e ELASTICSEARCH_URL="http://remotehost:9200" ekino/kibana:base
```

**Important Note:**
*The `remotehost` url has to be resolved by the frontend, so if working local you should consider updating your /etc/hosts file*
