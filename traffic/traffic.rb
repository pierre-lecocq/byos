#!/usr/bin/env ruby
# -*- mode: ruby; -*-

# File: traffic.rb
# Time-stamp: <2018-11-01 13:41:38>
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
  attr_reader :possible_requests, :recorded_ids, :sleep

  def initialize
    @recorded_ids = (1..250).to_a
    @possible_requests = {
      '/' => ['GET'],
      '/articles' => ['GET', 'POST'],
      '/articles/:id' => ['GET', 'PUT', 'DELETE']
    }
  end

  def pick_random_request
    id = 0
    addr, verbs = @possible_requests.to_a.sample

    if addr.include? ':id'
      id = @recorded_ids.sample.to_s
      addr = addr.gsub(':id', id)
    end

    [verbs.sample, addr, id]
  end

  def sleep_speed(factor)
    return @sleep if @sleep
    @sleep = {5 => 0.1, 4 => 0.2, 3 => 0.3, 2 => 0.4, 1 => 0.5 }[factor]
    return @sleep
  end

  def send_request(verb, addr, id)
    url = URI.parse addr

    case verb
    when 'POST'
      req = Net::HTTP::Post.new(url.to_s, {'Content-Type': 'text/json'})
      req.body = {"title": "A new title"}.to_json
    when 'PUT'
      req = Net::HTTP::Put.new(url.to_s, {'Content-Type': 'text/json'})
      req.body = {"title": "An updated title"}.to_json
    when 'DELETE'
      req = Net::HTTP::Delete.new(url.to_s)
      if id
        @recorded_ids = @recorded_ids - [id]
      end
    else
      req = Net::HTTP::Get.new(url.to_s)
    end

    res = Net::HTTP.start(url.host, url.port) do |http|
      http.request(req)
    end

    json_body = JSON.parse(res.body)

    @recorded_ids << json_body['id'].to_i if verb == 'POST'

    return json_body
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
    rand_req = traffic.pick_random_request
    result = traffic.send_request rand_req[0], options[:base] + rand_req[1], rand_req[2]
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
