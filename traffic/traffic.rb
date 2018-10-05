#!/usr/bin/env ruby
# -*- mode: ruby; -*-

# File: traffic.rb
# Time-stamp: <2018-10-04 23:44:49>
# Copyright (C) 2018 Pierre Lecocq
# Description:

require 'json'
require 'net/http'

class Traffic
  attr_reader :possible_requests

  def initialize
    @possible_requests = [
      '/',
      '/articles',
      '/articles/:id'
    ]
  end

  # Pick random request
  def pick_random_request
    addr = @possible_requests.sample
    addr.gsub(':id', (1 + rand(249)).to_s)
  end

  # Send a request
  def send_request(addr)
    url = URI.parse addr
    req = Net::HTTP::Get.new(url.to_s)
    res = Net::HTTP.start(url.host, url.port) do |http|
      http.request(req)
    end

    JSON.parse(res.body)
  rescue Exception => e
    { error: e.message }
  end
end

traffic = Traffic.new

reqs = 0
errors = []

begin
  while true
    sleep 0.5
    next if rand(2) == 0
    reqs += 1
    result = traffic.send_request 'http://localhost:8080' + traffic.pick_random_request
    if result.key? :error
      errors << result[:error]
      print 'x'
    else
      print '.'
    end
  end
rescue Interrupt, SignalException, Exception => e
  print "\n[Loop interrupted] #{e.message}"
ensure
  print "\n#{reqs} request sent\n"
  puts errors unless errors.empty?
end
