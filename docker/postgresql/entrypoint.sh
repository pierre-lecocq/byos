#!/bin/sh
# -*- mode: sh; -*-

# File: entrypoint.sh
# Time-stamp: <2018-11-01 11:17:41>
# Copyright (C) 2018 Pierre Lecocq
# Description:

set -o errexit

/usr/local/bin/postgres_exporter &

exec "$@"
