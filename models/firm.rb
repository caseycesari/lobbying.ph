class Firm
    include DataMapper::Resource
    
    property :id, Serial
    searchable_property :name, String
    searchable_property :address1, String
    searchable_property :address2, String
    searchable_property :address3, String
    searchable_property :city, String
    searchable_property :state, String
    searchable_property :zip, String
    searchable_property :phone, String
    searchable_property :email, String
end
