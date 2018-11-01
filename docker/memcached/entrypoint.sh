#!/bin/sh
# -*- mode: sh; -*-

# File: entrypoint.sh
# Time-stamp: <2018-11-01 09:27:17>
# Copyright (C) 2018 Pierre Lecocq
# Description:

set -o errexit

/usr/local/bin/memcached_exporter &

exec "$@"
