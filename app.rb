require 'rubygems'
require 'sinatra'
require 'compass'
require 'sass'
#require 'haml'

get '/' do
  erb :index
end

get '/stylesheets/:name.css' do
  scss(:"stylesheets/#{params[:name]}")
end
