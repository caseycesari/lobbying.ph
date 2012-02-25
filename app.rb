require 'rubygems'
require 'sinatra'
require 'compass'
require 'sass'
require 'data_mapper'

require 'models/lobbyist'

# setup db
DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/lobbying.db")
DataMapper.finalize
Lobbiyst.auto_upgrade!

get '/' do
  erb :index
end

get '/stylesheets/:name.css' do
  scss(:"stylesheets/#{params[:name]}")
end

# Helpers
helpers do
  def stylesheets(css_files) 
    css_files.each do |s|
      "<link src=\"/stylesheets/foo.css\""
    end
  end

  def link_to(url, text=url ,opts={})
    attributes = ""
    opts.each { |key, value| attributes << key.to_s << "=\"" << value << "\" "}
    "<a href=\"#{url}\" #{attributes}>#{text}</a>"
  end
end
