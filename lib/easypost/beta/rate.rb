# frozen_string_literal: true

# A Rate object contains all the details about the rate of a Shipment.
class EasyPost::Beta::Rate < EasyPost::Resource
  # Retrieve a list of stateless rates.
  def self.retrieve_stateless_rates(params = {}, api_key = nil)
    wrapped_params = {
      shipment: params,
    }

    response = EasyPost.make_request(:post, '/beta/rates', api_key, wrapped_params)
    EasyPost::Util.convert_to_easypost_object(response['rates'], api_key)
  end
end
