#!/bin/bash

s="/start.d"
if [ -d "/start.d" ]
then
  for script in $s/*
  do
    . $script
  done
fi