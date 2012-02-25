class Lobbyist
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

    @searchable = [:name, :address1, :address2, :address3, :city, :state, :zip, :phone, :email]

    def self.search(qstr, extra = {})
      like = "%#{qstr}%"

      search = @searchable.map { |fld| Lobbyist.all(extra.merge fld.like => like) }.reduce(:|)
    end

end
