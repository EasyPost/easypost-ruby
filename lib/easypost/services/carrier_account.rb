# frozen_string_literal: true

class EasyPost::Services::CarrierAccount < EasyPost::Services::Service
  CUSTOM_WORKFLOW_CARRIER_TYPES = %w[UpsAccount FedexAccount FedexSmartpostAccount].freeze
  MODEL_CLASS = EasyPost::Models::CarrierAccount

  # Create a carrier account
  def create(params = {})
    wrapped_params = { carrier_account: params }

    # For UPS and FedEx the endpoint is different
    create_url = if CUSTOM_WORKFLOW_CARRIER_TYPES.include?(params[:type])
                   'carrier_accounts/register'
                 else
                   'carrier_accounts'
                 end
    response = @client.make_request(:post, create_url, wrapped_params)

    EasyPost::InternalUtilities::Json.convert_json_to_object(response, MODEL_CLASS)
  end

  # Retrieve a carrier account
  def retrieve(id)
    response = @client.make_request(:get, "carrier_accounts/#{id}")

    EasyPost::InternalUtilities::Json.convert_json_to_object(response, MODEL_CLASS)
  end

  # Retrieve all carrier accounts
  def all(params = {})
    get_all_helper('carrier_accounts', MODEL_CLASS, params)
  end

  # Update a carrier account
  def update(id, params = {})
    wrapped_params = { carrier_account: params }
    response = @client.make_request(:put, "carrier_accounts/#{id}", wrapped_params)

    EasyPost::InternalUtilities::Json.convert_json_to_object(response, MODEL_CLASS)
  end

  # Delete a carrier account
  def delete(id)
    @client.make_request(:delete, "carrier_accounts/#{id}")

    # Return true if succeeds, an error will be thrown if it fails
    true
  end
end
