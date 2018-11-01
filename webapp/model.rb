#!/usr/bin/env ruby
# -*- mode: ruby; -*-

# File: model.rb
# Time-stamp: <2018-11-01 13:45:35>
# Copyright (C) 2018 Pierre Lecocq
# Description:

require 'memcached'
require 'pg'

class Model
  attr_reader :db_conn, :cache_conn

  def db_conn
    @db_conn = ::PG.connect host: ENV['DB_HOST'], dbname: ENV['DB_DATABASE'], user: ENV['DB_USERNAME'], password: ENV['DB_PASSWORD'] unless @db_conn
    @db_conn
  end

  def cache_conn
    @cache_conn = ::Memcached.new "#{ENV['CACHE_HOST']}:#{ENV['CACHE_PORT']}" unless @cache_conn
    @cache_conn
  end

  def close
    @db_conn.close if @db_conn
  end

  def db_fetch(options = {})
    q = "SELECT * FROM articles WHERE TRUE"
    q += " AND article_id = #{options[:id]}" if options.key?(:id)
    q += " LIMIT #{options[:limit]}" if options.key?(:limit)
    q += " OFFSET #{options[:offset]}" if options.key?(:offset)

    db_conn.exec(q).to_a
  end

  def cache_fetch(key)
    cache_conn.get key
  end

  def db_create(title)
    q = "INSERT INTO articles (title) VALUES ($1) RETURNING article_id"
    res = db_conn.exec_params q, [title]
    res.first['article_id'].to_i
  end

  def cache_create(key, json_data)
    cache_conn.set key, json_data
  end

  def db_update(id, title)
    q = "UPDATE articles SET title=$1 WHERE article_id=$2"
    db_conn.exec_params q, [title, id]
  end

  def db_delete(id)
    q = "DELETE FROM articles WHERE article_id=$1"
    db_conn.exec_params q, [id]
  end

  def cache_delete(key)
    cache_conn.delete key
  end
end
