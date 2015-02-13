#!/bin/bash

echo "$green ==> Starting ekino/elasticsearch:java7$reset"

if [ "${ELASTICSEARCH_AUTH}" = "none" ]
then
  echo "$cyan --> Removing basic auth$reset"
  sed -i 's/auth_basic/#auth_basic/' /etc/nginx/sites-available/default
else
  echo "$cyan --> Setting basic auth$reset"
  htpasswd -bc /etc/elasticsearch/htpasswd "${ELASTICSEARCH_USER:-"admin"}" "${ELASTICSEARCH_PASS:-"changeme"}"
fi