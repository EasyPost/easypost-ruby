# frozen_string_literal: true

# A Rate object contains all the details about the rate of a Shipment.
class EasyPost::Rate < EasyPost::Resource
  # Retrieving all Rate objects is not supported.
  def self.all(filters = {}, api_key = nil)
    raise NotImplementedError.new('Rate.all not implemented.')
  end
end
