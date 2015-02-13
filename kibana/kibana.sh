#!/bin/bash

sed -i '32d;33ielasticsearch: "'${ELASTICSEARCH_URL:-"http://localhost:9200"}'",' /opt/kibana/config.js
#sed -i '32d;33ielasticsearch: "http://172.17.42.1:9200",' /opt/kibana/config.js
