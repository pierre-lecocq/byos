#!/usr/bin/env ruby
# -*- mode: ruby; -*-

# File: index.rb
# Time-stamp: <2018-11-01 13:46:13>
# Copyright (C) 2018 Pierre Lecocq
# Description:

require 'json'
require 'sinatra/base'
require 'sinatra/reloader' if ENV['RACK_ENV'] == 'development'

require './model'

class MyApp < Sinatra::Base
  attr_reader :model

  # Configure
  configure do
    set :server, :puma
  end

  # Get model
  def model
    @model = Model.new unless @model
    @model
  end

  # Respond with JSON data
  def respond_with(status_code, data)
    status status_code
    content_type :json

    data[:map] = {
      '/' => ['GET'],
      '/articles' => ['GET', 'POST'],
      '/articles/:id' => ['GET', 'PUT', 'DELETE']
    }

    data.to_json
  end

  # Home route
  get '/' do
    respond_with 200, message: 'Hello'
  rescue Exception => e
    respond_with 400, error: e.message
  end

  # Articles route
  get '/articles' do
    page = params.key?(:page) ? params[:page].to_i : 1
    raise 'Invalid page' unless page > 0

    articles = model.db_fetch limit: 50, offset: ((page - 1) * 50)
    model.close

    respond_with 200, articles: articles
  rescue Exception => e
    respond_with 400, error: e.message
  end

  # Article route
  get '/articles/:id' do |id|
    id = id.to_i
    raise 'Invalid id' unless id > 0

    cache_key = "article:#{id}"
    begin
      json_data = model.cache_fetch cache_key
      article = ::JSON.parse json_data
    rescue Memcached::NotFound
      article = model.db_fetch(id: id).first
      model.cache_create cache_key, article.to_json
      model.close
    end

    raise 'Not found' unless article

    respond_with 200, article: article
  rescue Exception => e
    respond_with 400, error: e.message
  end

  # Create article
  post '/articles' do
    json_params = JSON.parse(request.body.read)

    raise 'Missing title parameter' unless json_params.key? 'title'
    raise 'Empty title parameter' if json_params['title'].empty?
    raise 'Too long title parameter' if json_params['title'].length > 1024

    id = model.db_create json_params['title']
    model.close

    respond_with 201, message: 'Created', id: id
  rescue Exception => e
    respond_with 400, error: e.message
  end

  # Update article
  put '/articles/:id' do |id|
    json_params = JSON.parse(request.body.read)

    raise 'Missing title parameter' unless json_params.key? 'title'
    raise 'Empty title parameter' if json_params['title'].empty?
    raise 'Too long title parameter' if json_params['title'].length > 1024

    model.db_update id, json_params['title']
    model.close

    begin
      model.cache_delete "article:#{id}"
    rescue Memcached::NotFound
      # Don't care
    end

    respond_with 200, message: 'Updated'
  rescue Exception => e
    respond_with 400, error: e.message
  end

  # Delete article
  delete '/articles/:id' do |id|
    model.db_delete id

    begin
      model.cache_delete "article:#{id}"
    rescue Memcached::NotFound
      # Don't care
    end

    respond_with 200, message: 'Deleted'
  rescue Exception => e
    respond_with 400, error: e.message
  end
end
