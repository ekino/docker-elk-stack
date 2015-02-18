#!/bin/bash

[[ ! -z "$STARTUP_DEBUG" ]] && set -x

s="/start.d"
if [ -d "/start.d" ]
then
  for script in $s/*
  do
    . $script
  done
fi