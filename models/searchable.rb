module Searchable
    module ClassMethods
        def search(qstr, extra = {})
            like = "%#{qstr}%"
            @searchable.map { |fld| Lobbyist.all(extra.merge fld.like => like) }.reduce(:|)
        end

        def searchable_property *args
          @searchable ||= []
          @searchable << args[0]
          property *args
        end

    end

    def self.included includer
        includer.extend ClassMethods
    end
end
