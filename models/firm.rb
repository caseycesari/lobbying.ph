class Firm
    include DataMapper::Resource
    
    property :id, Serial
    property :name, String
    property :address1, String
    property :address2, String
    property :address3, String
    property :city, String
    property :state, String
    property :zip, String
    property :phone, String
    property :email, String
    
    has n, :lobbyists
    has n, :principals, :through => Resource, :required => false
end
