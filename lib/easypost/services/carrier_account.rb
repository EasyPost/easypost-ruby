# frozen_string_literal: true

class EasyPost::Services::CarrierAccount < EasyPost::Services::Service
  CUSTOM_WORKFLOW_CARRIER_TYPES = %w[FedexAccount FedexSmartpostAccount].freeze
  CARRIER_ACCOUNT_TYPES_WITH_CUSTOM_OAUTH = %w[
    AmazonShippingAccount UpsAccount UpsMailInnovationsAccount
    UpsSurepostAccount
  ].freeze
  MODEL_CLASS = EasyPost::Models::CarrierAccount # :nodoc:

  # Create a carrier account
  def create(params = {})
    carrier_account_type = params[:type]
    wrapped_params = { select_top_layer_key(carrier_account_type).to_sym => params }

    # For UPS and FedEx the endpoint is different
    create_url = if CUSTOM_WORKFLOW_CARRIER_TYPES.include?(carrier_account_type)
                   'carrier_accounts/register'
                 elsif CARRIER_ACCOUNT_TYPES_WITH_CUSTOM_OAUTH.include?(carrier_account_type)
                   'carrier_accounts/register_oauth'
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
    carrier_account = retrieve(id)
    wrapped_params = { select_top_layer_key(carrier_account[:type]).to_sym => params }
    response = @client.make_request(:put, "carrier_accounts/#{id}", wrapped_params)

    EasyPost::InternalUtilities::Json.convert_json_to_object(response, MODEL_CLASS)
  end

  # Delete a carrier account
  def delete(id)
    @client.make_request(:delete, "carrier_accounts/#{id}")

    # Return true if succeeds, an error will be thrown if it fails
    true
  end

  private

  # Select the top-layer key for the carrier account creation/update request based on the carrier type.
  def select_top_layer_key(carrier_account_type)
    if CARRIER_ACCOUNT_TYPES_WITH_CUSTOM_OAUTH.include?(carrier_account_type)
      'carrier_account_oauth_registrations'
    else
      'carrier_account'
    end
  end
end
