# frozen_string_literal: true

class EasyPost::Services::Address < EasyPost::Services::Service
  MODEL_CLASS = EasyPost::Models::Address

  # Create an address.
  def create(params = {})
    address = params.reject { |k, _| [:verify, :verify_strict].include?(k) }

    wrapped_params = { address: address }

    if params[:verify]
      wrapped_params[:verify] = params[:verify]
    end

    if params[:verify_strict]
      wrapped_params[:verify_strict] = params[:verify_strict]
    end

    response = @client.make_request(:post, 'addresses', MODEL_CLASS, params)

    EasyPost::InternalUtilities::Json.convert_json_to_object(response, MODEL_CLASS)
  end

  # Create and verify an Address in one call.
  def create_and_verify(params = {})
    wrapped_params = {}
    wrapped_params[:address] = params

    response = @client.make_request(:post, 'addresses/create_and_verify', MODEL_CLASS, wrapped_params)

    EasyPost::InternalUtilities::Json.convert_json_to_object(response, MODEL_CLASS).address
  end

  # Verify an Address.
  def verify(id)
    response = @client.make_request(:get, "addresses/#{id}/verify", MODEL_CLASS)

    EasyPost::InternalUtilities::Json.convert_json_to_object(response, MODEL_CLASS).address
  end

  # Retrieve an Address.
  def retrieve(id)
    response = @client.make_request(:get, "addresses/#{id}", MODEL_CLASS)

    EasyPost::InternalUtilities::Json.convert_json_to_object(response, MODEL_CLASS)
  end

  # Retrieve all Addresses.
  def all(params = {})
    filters = { 'key' => 'addresses' }

    get_all_helper('addresses', MODEL_CLASS, params, filters)
  end

  # Get the next page of addresses.
  def get_next_page(collection, page_size = nil)
    raise EasyPost::Errors::EndOfPaginationError.new unless has_more_pages?(collection)

    params = { before_id: collection.addresses.last.id }
    params[:page_size] = page_size unless page_size.nil?

    all(params)
  end
end
