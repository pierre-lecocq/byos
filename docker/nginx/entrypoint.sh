#!/bin/sh
# -*- mode: sh; -*-

# File: entrypoint.sh
# Time-stamp: <2018-11-01 14:17:01>
# Copyright (C) 2018 Pierre Lecocq
# Description:

set -o errexit

/usr/local/bin/nginx-prometheus-exporter -nginx.scrape-uri http://localhost:8080/stub_status &

exec "$@"
