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

get '/graphdata' do
  @lobbyists = Lobbyist.all()
  @lobbyists = @lobbyists.map do |lobbyist| 
    l = {:id => "lobbyist_"+ lobbyist.id.to_s, :type => "lobbyist", :name => lobbyist.name, :firm_id => "firm_#{lobbyist.firm_id}"}
    if (lobbyist.firm_id != nil)
      l[:firmname] = Firm.get(lobbyist.firm_id).name
    end
    l
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
