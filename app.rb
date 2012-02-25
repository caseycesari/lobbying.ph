$:.unshift(File.dirname(__FILE__))

require 'rubygems'
require 'sinatra'
require 'compass'
require 'sass'
require 'data_mapper'

require 'models/lobbyist'
require 'models/firm'
require 'models/principal'

# setup db
DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/lobbying.db")
DataMapper.finalize
Lobbyist.auto_upgrade!
Firm.auto_upgrade!
Principal.auto_upgrade!

get '/' do
  @all_lobbyists = Lobbyist.all()
  @firms = Firm.all()
  @principals = Principal.all()
  @lobbyists = Lobbyist.all(:order => [ :id.desc ], :limit => 20)

  if params[:search]
    @lobbyists = Lobbyist.search(params[:search])
  end

  erb :index
end

get '/stylesheets/:name.css' do
  scss(:"stylesheets/#{params[:name]}")
end


get '/results' do

  @lobbyists = Lobbyist.search(params[:search])
  @firms = Firm.search(params[:search])
  @principals = Principal.search(params[:search])

  erb :results
end

get '/lobbyist/:id' do
	@data = Lobbyist.get(params[:id])
	erb :detail
end

get '/firm/:id' do
	@data = Firm.get(params[:id])
	erb :detail
end

get '/principal/:id' do
	@data = Principal.get(params[:id])
	erb :detail
end

get '/about' do
	erb :about
end

# Helpers
helpers do
  def link_to(url, text=url, opts={})
    attributes = ""
    opts.each { |key, value| attributes << key.to_s << "=\"" << value << "\" "}
    "<a href=\"#{url}\" #{attributes}>#{text}</a>"
  end
end
