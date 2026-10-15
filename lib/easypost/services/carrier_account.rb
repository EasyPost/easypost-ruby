# frozen_string_literal: true

class EasyPost::Services::CarrierAccount < EasyPost::Services::Service
  CARRIER_ACCOUNT_CREATE_ENDPOINT_TYPES = {
    'carrier_accounts/open' => %w[
      FedexDefaultAccount
      GofoWalletAccount
      UpsDapAccount
      UniUniWalletAccount
      VehoWalletAccount
    ].freeze,
    'carrier_accounts/register' => %w[
      FedexAccount
      FedexSmartpostAccount
    ].freeze,
    'carrier_accounts/register_oauth' => %w[
      AmazonShippingAccount
      UpsAccount
      UpsMailInnovationsAccount
      UpsSurepostAccount
      UspsShipAccount
    ].freeze,
  }.freeze
  MODEL_CLASS = EasyPost::Models::CarrierAccount # :nodoc:

  # Create a carrier account
  def create(params = {})
    carrier_account_type = params[:type]
    create_url = select_carrier_account_creation_endpoint(carrier_account_type)
    wrapped_params = { select_top_layer_key(create_url).to_sym => params }

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

  # Select the top-layer key for the carrier account creation/update request based on the create endpoint.
  def select_top_layer_key(create_url)
    if create_url == 'carrier_accounts/register_oauth'
      'carrier_account_oauth_registrations'
    else
      'carrier_account'
    end
  end

  # Determines which API endpoint to use for the creation call.
  def select_carrier_account_creation_endpoint(carrier_account_type)
    CARRIER_ACCOUNT_CREATE_ENDPOINT_TYPES.each do |endpoint, carrier_account_types|
      return endpoint if carrier_account_types.include?(carrier_account_type)
    end

    'carrier_accounts'
  end
end
