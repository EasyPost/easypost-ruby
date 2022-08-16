# frozen_string_literal: true

# CustomsInfo objects contain CustomsItem objects and all necessary information for the generation of customs forms required for international shipping.
class EasyPost::CustomsInfo < EasyPost::Resource
  # Retrieve a list of CustomsInfo objects
  def self.all(filters = {}, api_key = nil)
    raise NotImplementedError.new('CustomsInfo.all not implemented.')
  end
end
