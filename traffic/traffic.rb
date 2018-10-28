#!/usr/bin/env ruby
# -*- mode: ruby; -*-

# File: traffic.rb
# Time-stamp: <2018-10-28 13:05:30>
# Copyright (C) 2018 Pierre Lecocq
# Description:

require 'json'
require 'net/http'
require 'optparse'

################################################################################

options = {
  speed: 1,
  base: 'http://localhost:8080'
}

OptionParser.new do |opts|
  opts.banner = "Usage: traffic.rb [options]"

  opts.on('-b', '--base-url URL', Integer, 'Base URL of the web application (default is http://localhost:8080)') do |v|
    options[:base] = v
  end

  opts.on('-s', '--speed NUMBER', Integer, 'Speed factor from 1 to 5 (default is 1)') do |v|
    options[:speed] = v.to_i
    options[:speed] = 5 if options[:speed] > 5
    options[:speed] = 1 if options[:speed] < 1
  end

  opts.on_tail('-h', '--help', 'Show this message') do
    puts opts
    exit
  end
end.parse!

################################################################################

class Traffic
  attr_reader :possible_requests, :sleep

  def initialize
    @possible_requests = [
      '/',
      '/articles',
      '/articles/:id'
    ]
  end

  def pick_random_request
    addr = @possible_requests.sample
    addr.gsub(':id', (1 + rand(249)).to_s)
  end

  def sleep_speed(factor)
    return @sleep if @sleep
    @sleep = case factor
             when 5
               0.1
             when 4
               0.2
             when 3
               0.3
             when 2
               0.4
             else
               0.5
             end
    return @sleep
  end

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

################################################################################

traffic = Traffic.new

reqs = 0
errors = []

begin
  while true
    sleep traffic.sleep_speed(options[:speed])
    next if rand(2) == 0
    reqs += 1
    result = traffic.send_request options[:base] + traffic.pick_random_request
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
