#!/usr/bin/env ruby
# -*- mode: ruby; -*-

# File: index.rb
# Time-stamp: <2018-10-04 14:31:22>
# Copyright (C) 2018 Pierre Lecocq
# Description:

require 'json'
require 'memcached'
require 'pg'
require 'sinatra/base'
require 'sinatra/reloader' if ENV['RACK_ENV'] == 'development'

class MyApp < Sinatra::Base
  # Connections attributes
  attr_reader :db_conn, :cache_conn

  # Configure
  configure do
    set :server, :puma
  end

  # Get DB connection
  def db_conn
    @db_conn = PG.connect host: ENV['DB_HOST'], dbname: ENV['DB_DATABASE'], user: ENV['DB_USERNAME'], password: ENV['DB_PASSWORD'] unless @db_conn
    @db_conn
  end

  # Get cache connection
  def cache_conn
    @cache_conn = Memcached.new "#{ENV['CACHE_HOST']}:#{ENV['CACHE_PORT']}" unless @cache_conn
    @cache_conn
  end

  # Get articles from database
  def get_articles(options = {})
    q = "SELECT * FROM articles WHERE TRUE"
    q += " AND article_id = #{options[:id]}" if options.key?(:id)
    q += " LIMIT #{options[:limit]}" if options.key?(:limit)
    q += " OFFSET #{options[:offset]}" if options.key?(:offset)

    db_conn.exec(q).to_a
  end

  # Home route
  get '/' do
    content_type :json
    { route: 'home' }.to_json
  end

  # Articles route
  get '/articles' do
    page = params.key?(:page) ? params[:page].to_i : 1
    raise 'Invalid page' unless page > 0

    articles = get_articles limit: 50, offset: ((page - 1) * 50)

    content_type :json
    { route: 'articles', articles: articles }.to_json
  end

  # Article route
  get '/articles/:id' do |id|
    id = id.to_i
    raise 'Invalid id' unless id > 0

    cache_key = "article:#{id}"
    begin
      json_data = cache_conn.get cache_key
      article = JSON.parse json_data
    rescue Memcached::NotFound
      article = get_articles(id: id).first
      cache_conn.set cache_key, article.to_json
    end

    content_type :json
    { route: 'article', article: article }.to_json
  end
end
