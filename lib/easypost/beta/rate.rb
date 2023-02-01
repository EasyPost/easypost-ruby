# frozen_string_literal: true

# Stateless that uses Rate as the object.
class EasyPost::Beta::Rate < EasyPost::Resource
  # Retrieve a list of stateless rates.
  def self.retrieve_stateless_rate(params = {}, api_key = nil)
    wrapped_params = {
      shipment: params,
    }

    response = EasyPost.make_request(:post, '/beta/rates', api_key, wrapped_params)
    EasyPost::Util.convert_to_easypost_object(response['rates'], api_key)
  end
end
