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

echo "$cyan --> Setting supervisord loglevel to ${LOG_LEVEL="trace"}$reset"
sed -i '/^supervisord/s/trace/'$LOG_LEVEL'/' /start.d/99-supervisord
