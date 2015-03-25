#!/bin/bash


echo "$green ==> Starting ekino/logstash:elasticsearch$reset"
mkdir -p /var/log/logstash

echo "$cyan --> Creating self-signed x509 certificate$reset"

if [ -z "$NO_SSL_CERTS" ]
then
  # generate certificate
  SSLPATH="/etc/logstash/ssl"
  mkdir -p "$SSLPATH"
  O="${CERTIFICATE_O:-"Ekino"}"
  OU="${CERTIFICATE_OU:-"DevOps Team"}"
  CN="${CERTIFICATE_CN:-"devops.ekino.com"}"
  EMAIL="${CERTIFICATE_EMAIL:-"changeme@ekino.com"}"

  openssl req \
    -x509     \
    -batch    \
    -nodes    \
    -sha256   \
    -days   3650     \
    -newkey rsa:2048 \
    -keyout $SSLPATH/logstash-forwarder.key \
    -out    $SSLPATH/logstash-forwarder.crt \
    -subj   "/C=FR/ST=Ile de France/L=Paris/O=${O}/OU=${OU}/CN=${CN}/emailAddress=${EMAIL}"
else
  if [ ! -f "$SSLPATH/logstash-forwarder.key" ] || [ ! -f "$SSLPATH/logstash-forwarder.crt" ]
  then
    echo "$red   > ERROR: Missing files in $SSLPATH"
    echo "$red     If you \$NO_SSL_CERTS environment variable so no SSL cert are generated at startup"
    echo "$red     But you now should start your container with the relevant volume => \`-v /path/to/your/ssl/files:/etc/logstash/ssl\`"
  fi
fi

