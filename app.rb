$:.unshift(File.dirname(__FILE__))

require 'rubygems'
require 'sinatra'
require 'compass'
require 'sass'
require 'data_mapper'
require 'json'

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
  @lobbyists = Lobbyist.all(:order => [ :id.desc ], :limit => 20)	
  erb :index
end

get '/stylesheets/:name.css' do
  scss(:"stylesheets/#{params[:name]}")
end

get '/graphdata' do
  @lobbyists = Lobbyist.all()
  @lobbyists = @lobbyists.map do |lobbyist| 
    l = {:id => "lobbyist_"+ lobbyist.id.to_s, :type => "lobbyist", :name => lobbyist.name, :firm_id => "firm_#{lobbyist.firm_id}"}
  end
  @firms = Firm.all()
  @firms = @firms.map do |firm| 
     l = {:id => "firm_"+ firm.id.to_s, :type => "firm", :name => firm.name}
   end
  @nodes = @lobbyists + @firms
  erb :graphdata
end

get '/graphdata.json' do
  content_type :json
  @lobbyists = Lobbyist.all()	
  @lobbyists.to_json
end

# Helpers
helpers do
  def link_to(url, text=url, opts={})
    attributes = ""
    opts.each { |key, value| attributes << key.to_s << "=\"" << value << "\" "}
    "<a href=\"#{url}\" #{attributes}>#{text}</a>"
  end
end
