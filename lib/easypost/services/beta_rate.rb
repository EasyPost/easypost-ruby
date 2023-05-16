# frozen_string_literal: true

# A Rate service contains all the details about the rate of a Shipment.
class EasyPost::Services::BetaRate < EasyPost::Services::Service
  # Retrieve a list of stateless rates.
  def retrieve_stateless_rates(params = {})
    wrapped_params = {
      shipment: params,
    }

    @client.make_request(:post, 'rates', EasyPost::Models::Rate, wrapped_params, 'beta').rates
  end
end
