#!/bin/bash

echo " ==> Starting ekino/elasticsearch:java7"

if [ "${ELASTICSEARCH_AUTH}" = "none" ]
then
  echo " --> Remove basic auth"
  sed -i 's/auth_basic/#auth_basic/' /etc/nginx/sites-available/default
fi

echo " --> Set htpassw (not used if basic auth is removed)"
htpasswd -bc /etc/elasticsearch/htpasswd "${ELASTICSEARCH_USER:-"admin"}" "${ELASTICSEARCH_PASS:-"changeme"}"