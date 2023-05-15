# frozen_string_literal: true

# A Rate object contains all the details about the rate of a Shipment.
class EasyPost::Services::Rate < EasyPost::Services::Service
  # Retrieve a Rate
  def retrieve(id)
    @client.make_request(:get, "rates/#{id}", EasyPost::Models::Rate)
  end
end
