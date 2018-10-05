#!/usr/bin/env ruby
# -*- mode: ruby; -*-

# File: config.ru
# Time-stamp: <2018-10-02 18:08:22>
# Copyright (C) 2018 Pierre Lecocq
# Description:

# Run with
#
#    bundle exec rackup
#

require File.expand_path('index', File.dirname(__FILE__))

run MyApp
