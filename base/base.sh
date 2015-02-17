#!/bin/bash

cyan="$(tput setaf 6)"
green="$(tput setaf 2)"
bgreen="$(tput bold ; tput setaf 2)"
red="$(tput setaf 1)"

bold="$(tput bold)"
reset="$(tput sgr0)"

echo -n "$bold
        _    _
    ___| | _(_)_ __   ___
   / _ \ |/ / | '_ \ / _ \ 
  |  __/   <| | | | | (_) |
   \___|_|\_\_|_| |_|\___(_)

$reset"

echo "$green ==> Starting ekino/base$reset"

echo "$cyan --> Setting supervisor loglevel to ${SUPERVISOR_LOGLEVEL="info"}$reset"
sed -i '/^supervisord/s/trace/'$SUPERVISOR_LOGLEVEL'/' /start.d/99-supervisord
mkdir -p /var/log/supervisor

[ "$DEBUG" = "true" ] && set -x
