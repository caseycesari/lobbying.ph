$:.unshift(File.dirname(__FILE__))

require 'rubygems'
require 'sinatra'
require 'compass'
require 'sass'
require 'data_mapper'

require 'models/lobbyist'

# setup db
DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/lobbying.db")
DataMapper.finalize
Lobbyist.auto_upgrade!

get '/' do
  erb :index
end

get '/stylesheets/:name.css' do
  scss(:"stylesheets/#{params[:name]}")
end
