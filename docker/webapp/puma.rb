#!/usr/bin/env ruby
# -*- mode: ruby; -*-

# File: puma.rb
# Time-stamp: <2018-10-04 09:12:34>
# Copyright (C) 2018 Pierre Lecocq
# Description:

name = 'webapp'
root = '/webapp'

workers `nproc`.to_i
threads 3, 16

# daemonize
environment 'development'

bind "tcp://0.0.0.0:9292"
# bind "unix:///tmp/puma.#{name}.sock"
pidfile "/tmp/puma.#{name}.pid"
state_path "/tmp/puma.#{name}.state"
rackup "#{root}/config.ru"

# Redirect STDOUT and STDERR to files specified.3rd parameter is "append"
stdout_redirect "/tmp/puma.#{name}.log", "/tmp/puma.#{name}.err.log", true

preload_app!
