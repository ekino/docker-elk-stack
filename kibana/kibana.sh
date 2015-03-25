#!/bin/bash

echo "$green ==> Starting ekino/kibana:base$reset"

echo "$cyan --> Setting elasticsearch url$reset"
sed -i "/^elasticsearch_url:/s,http://localhost:9200,${ELASTICSEARCH_URL:-"http://localhost:9200"}," /opt/kibana/config/kibana.yml

#sed -i '32d;33ielasticsearch: "'${ELASTICSEARCH_URL:-"http://localhost:9200"}'",' /opt/kibana/config.js
#sed -i '32d;33ielasticsearch: "http://172.17.42.1:9200",' /opt/kibana/config.js
