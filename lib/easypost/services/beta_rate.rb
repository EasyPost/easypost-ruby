# frozen_string_literal: true

class EasyPost::Services::BetaRate < EasyPost::Services::Service
  # Retrieve a list of stateless rates.
  def retrieve_stateless_rates(params = {})
    wrapped_params = {
      shipment: params,
    }
    response = @client.make_request(:post, 'rates', wrapped_params, 'beta')

    EasyPost::InternalUtilities::Json.convert_json_to_object(response, EasyPost::Models::Rate).rates
  end
end
