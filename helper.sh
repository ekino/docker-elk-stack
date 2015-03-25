#!/bin/bash
#set -x

command -v docker || curl http://get.docker.com/ | sh

cyan="$(tput setaf 6)"
green="$(tput setaf 2)"
bgreen="$(tput bold ; tput setaf 2)"
red="$(tput setaf 1)"
bred="$(tput bold ; tput setaf 1)"
reset="$(tput sgr0)"

ES_NAME=es_logstash
FW_NAME=forwarder
K_NAME=kibana

ELASTIC_FQDN="elasticsearch.example.com"
LOGSTASH_FQDN="logstash.example.com"
LUMBERJACK_URL="${LOGSTASH_FQDN}:5000"

echo ${1%:*}

for args in $@
do
  case ${1%:*} in

    'clear'|'clean') # ========================================================

      echo -e "\n${cyan}==> Killing and removing running containers${reset}"
      docker rm $(docker kill $ES_NAME $FW_NAME $K_NAME)
      [ "${1#*:}" = "images" ] && \
      echo -e "\n${cyan}==> Removing untagged/dangled images${reset}" && \
      docker rmi $(docker images -qf dangling=true)
      ;;

    'build') # ================================================================

      # using cache or not ----------------------------------------------------

      nocache=
      [ "${1#*:}" = "nocache" ] && nocache="--no-cache"

      # building elasticsearch+logstah ----------------------------------------

      echo -e "\n${cyan}==> Building base, java7, elasticsearch and logstash images${reset}"
      j=""; for i in java7 elasticsearch logstash; do echo "$(tput bold)--- $i ---$(tput sgr0)"; docker build $nocache -t ekino/$i$j $i; j=":$i"; done

      # building kibana -------------------------------------------------------

      echo -e "\n${cyan}==> Building base and kibana images${reset}"
      j=""; for i in kibana; do echo "$(tput bold)--- $i ---$(tput sgr0)"; docker build $nocache -t ekino/$i$j $i; j=":$i"; done
      ;;

    'run') #===================================================================

      # Starting elasticsearch and logstash -----------------------------------

      docker run --name $ES_NAME -d \
        -p 9200:9200 \
        -p 5000:5000 \
        -e CERTIFICATE_CN=$LOGSTASH_FQDN \
        ekino/logstash:elasticsearch

      w=5 ; echo -e "\n${cyan}==> Waiting ${w}s for elasticsearch+logstash container${reset}" ; sleep $w
      docker logs $(docker ps -lq)

      # Starting logstash-forwarder -------------------------------------------

      secrets=$(mktemp -d)
      docker cp $ES_NAME:/etc/logstash/ssl $secrets
      docker run --name $FW_NAME -d \
        --link $ES_NAME:$LOGSTASH_FQDN \
        -e LUMBERJACK_ENDPOINT=$LUMBERJACK_URL \
        -v $secrets/ssl:/etc/logstash/ssl \
        ekino/logstash-forwarder

      w=5 ; echo -e "\n${cyan}==> Waiting ${w}s for forwarder container${reset}" ; sleep $w
      docker logs $(docker ps -lq)

      # Starting kibana -------------------------------------------------------

      docker run --name $K_NAME -d \
        --link $ES_NAME:$ELASTIC_FQDN \
        -p 80:5601 \
        -e ELASTICSEARCH_URL="http://$ELASTIC_FQDN:9200" \
        ekino/kibana:base

      w=5 ; echo -e "\n${cyan}==> Waiting ${w}s for kibana container${reset}" ; sleep $w
      docker logs $(docker ps -lq)

      # The end ---------------------------------------------------------------

      cat <<EOF
  ${green}
  Check the dashboard :
  ${cyan}
    - open your browser and go to http://localhost/
  ${reset}
EOF
      ;;
  esac
  shift
done 3>&1 1>&2 2>&3 | awk '{print "'$red'" $0 "'$reset'"}'
