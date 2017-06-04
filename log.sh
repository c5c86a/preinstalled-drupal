#!/usr/bin/env bash

tail -n 2 /var/log/apache2/access.log
tail -n 50 /var/log/apache2/error.log
tail -n 50 /var/log/mysql/error.log
