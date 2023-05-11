# frozen_string_literal: true

# The CarrierAccount encapsulates your credentials with the carrier.
class EasyPost::Services::CarrierAccount < EasyPost::Services::Service
  CUSTOM_WORKFLOW_CARRIER_TYPES = %w[UpsAccount FedexAccount].freeze
  CLASS = EasyPost::Models::CarrierAccount

  # Create a carrier account
  def create(params = {})
    wrapped_params = { carrier_account: params }

    # For UPS and FedEx the endpoint is different
    create_url = if CUSTOM_WORKFLOW_CARRIER_TYPES.include?(params[:type])
                   'carrier_accounts/register'
                 else
                   'carrier_accounts'
                 end

    @client.make_request(:post, create_url, CLASS, wrapped_params)
  end

  # Retrieve a carrier account
  def retrieve(id)
    @client.make_request(:get, "carrier_accounts/#{id}", CLASS)
  end

  # Retrieve all carrier accounts
  def all(params = {})
    @client.make_request(:get, 'carrier_accounts', CLASS, params)
  end

  # Update a carrier account
  def update(id, params)
    wrapped_params = { carrier_account: params }
    @client.make_request(:put, "carrier_accounts/#{id}", CLASS, wrapped_params)
  end

  # Delete a carrier account
  def delete(id)
    @client.make_request(:delete, "carrier_accounts/#{id}")
  end
end
