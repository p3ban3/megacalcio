require 'dm-core'
require 'dm-migrations'
require "do_sqlite3"
require "dm-sqlite-adapter"
require 'dm-types'
require "json"
require "dm-validations"
#require 'sinatra-authentication'
#require 'sinbook'

DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/data.sqlite")

require_relative "giocatore"
require_relative "squadra"
require_relative "dado"
require_relative "db"

require "./users"


DataMapper.finalize