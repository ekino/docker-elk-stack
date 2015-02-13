#!/bin/bash
#set -x

command -v docker || curl http://get.docker.com/ | sh

cyan="$(tput setaf 6)"
green="$(tput setaf 2)"
bgreen="$(tput bold ; tput setaf 2)"
red="$(tput setaf 1)"
bred="$(tput bold ; tput setaf 1)"
reset="$(tput sgr0)"

EL_NAME=elasticsearch-logstash.local
K_NAME=kibana.local

echo ${1%:*}

for args in $@
do
  case ${1%:*} in
    'clear'|'clean')
      echo -e "\n${cyan}==> Killing and removing running containers${reset}"
      docker rm $(docker kill $EL_NAME $K_NAME)
      [ "${1#*:}" = "all" ] && \
      echo -e "\n${cyan}==> Removing untagged/dangled images${reset}" && \
      docker rmi $(docker images -qf dangling=true)
      ;;
    'build')
      # using cache or not
      nocache=
      [ "${1#*:}" = "nocache" ] && nocache="--no-cache"

      # building elasticsearch+logstah
      echo -e "\n${cyan}==> Building base, java7, elasticsearch and logstash images${reset}"
      j=""; for i in base java7 elasticsearch logstash; do docker build -t ekino/$i$j $i; j=":$i"; done
      # building kibana
      echo -e "\n${cyan}==> Building base and kibana images${reset}"
      j=""; for i in base kibana; do docker build -t ekino/$i$j $i; j=":$i"; done
      ;;
    'run')
      docker run --name $EL_NAME -d -p 9200:9200 -p 5000:5000 -e ELASTICSEARCH_AUTH=none ekino/logstash:elasticsearch
      w=5 ; echo -e "\n${cyan}==> Waiting ${w}s for elasticsearch+logstash container${reset}" ; sleep $w
      docker logs $(docker ps -lq)

      docker run --name $K_NAME --link $EL_NAME:$EL_NAME -d -p 80:8080 -e ELASTICSEARCH_URL="http://$EL_NAME:9200" ekino/kibana:base
      w=5 ; echo -e "\n${cyan}==> Waiting ${w}s for kibana container${reset}" ; sleep $w
      docker logs $(docker ps -lq)

      if [[ $(host "$EL_NAME" | grep -c "not found") -ne 0 ]] && [[ $(grep -c "$EL_NAME" /etc/hosts) -eq 0 ]]
      then
        echo -e "\n${cyan}==> Adding '$EL_NAME' entry to /etc/hosts ${bred}(requires sudo)${reset}"
        sudo sed -i '0,/^127.0.0.1/s/$/ '$EL_NAME'/' /etc/hosts
      fi

      # The end
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
