require 'restclient/components'
require 'active_support/core_ext'

class LobbyingData
  attr_reader :data

  def initialize(url)
    get_data url
  end

  get_data(url)
    xml_response = RestClient.get(url)

    if xml_response.code == 200 || xml_response.code == 304
      @data = OpenStruct.new(Hash.from_xml(xml_response))
    else
      @data = "error: #{xml_response.code}"
    end
  end
end
