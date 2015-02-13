#!/bin/bash

echo "$bgreen"
echo " ==> Starting supervisord"
echo "$reset"

supervisord -n -e trace -c /etc/supervisor/supervisord.conf
