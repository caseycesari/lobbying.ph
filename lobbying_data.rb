require 'restclient/components'
require 'active_support/core_ext'

class LobbyingData
  attr_reader :data

  def initialize(url)
    get_data url
  end

  private

  # Calls the api to get xml data
  #
  # @param [url] the url of the api to call
  #
  # @return an OpenStruct containing the returned data or an error
  def get_data(url)
    xml = RestClient.get(url)

    if xml.code == 200
      @data = hashes_to_ostruct(Hash.from_xml(xml))
    else
      @data = "error: #{xml.code}" #TODO: this is obviously sketchy.
    end
  end

  # Recursively turns hash values into an OpenStruct so dot notation can be used to traverse in the template.
  #
  # @param [object] a Hash object to turn into an OpenStruct 
  #
  # @return an OpenStruct whose child values are all also OpenStructs
  def hashes_to_ostruct(object)
    return case object
    when Hash
      object = object.clone
      object.each do |key, value|
        object[key] = hashes_to_ostruct(value)
      end
      OpenStruct.new(object)
    when Array
      object = object.clone
      object.map! { |i| hashes_to_ostruct(i) }
    else
      object
    end
  end 
end
