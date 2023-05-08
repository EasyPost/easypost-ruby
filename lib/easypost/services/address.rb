# frozen_string_literal: true

# Address objects are used to represent people, places, and organizations in a number of contexts.
class EasyPost::Services::Address < EasyPost::Services::Service
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

    @client.make_request(:post, 'addresses', EasyPost::Models::Address, params)
  end

  # Create and verify an Address in one call.
  def create_and_verify(params = {})
    wrapped_params = {}
    wrapped_params[:address] = params

    @client.make_request(:post, 'addresses/create_and_verify', EasyPost::Models::Address, wrapped_params).address
  end

  # Verify an Address.
  def verify(id)
    @client.make_request(:get, "addresses/#{id}/verify", EasyPost::Models::Address).address
  end

  # Retrieve an Address.
  def retrieve(id)
    @client.make_request(:get, "addresses/#{id}", EasyPost::Models::Address)
  end

  # Retrieve all Addresses.
  def all(filters = {})
    @client.make_request(:get, 'addresses', EasyPost::Models::Address, filters)
  end

  # Get the next page of addresses.
  def get_next_page(collection, page_size = nil)
    # get_next_page_exec(method(:all), collection, collection.addresses, page_size)
    params = {}
    params[:before_id] = collection.addresses.last.id
    unless page_size.nil?
      params[:page_size] = page_size
    end

    @client.make_request(:get, 'addresses', EasyPost::Models::Address, params)
  end
end
