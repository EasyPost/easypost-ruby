# frozen_string_literal: true

# Address objects are used to represent people, places, and organizations in a number of contexts.
class EasyPost::Address < EasyPost::Resource
  attr_accessor :message # Backwards compatibility

  # Create an Address.
  def self.create(params = {}, api_key = nil)
    address = params.reject { |k, _| [:verify, :verify_strict].include?(k) }

    wrapped_params = { address: address }

    if params[:verify]
      wrapped_params[:verify] = params[:verify]
    end

    if params[:verify_strict]
      wrapped_params[:verify_strict] = params[:verify_strict]
    end

    response = EasyPost.make_request(:post, url, api_key, wrapped_params)
    EasyPost::Util.convert_to_easypost_object(response, api_key)
  end

  # Create and verify an Address in one call.
  def self.create_and_verify(params = {}, api_key = nil)
    wrapped_params = {}
    wrapped_params[class_name.to_sym] = params
    response = EasyPost.make_request(:post, "#{url}/create_and_verify", api_key, wrapped_params)

    EasyPost::Util.convert_to_easypost_object(response['address'], api_key)
  end

  # Verify an Address.
  def verify
    response = EasyPost.make_request(:get, "#{url}/verify", @api_key)

    EasyPost::Util.convert_to_easypost_object(response['address'], api_key)
  end

  # Get the next page of addresses.
  def self.get_next_page(collection, page_size = nil)
    get_next_page_exec(method(:all), collection, collection.addresses, page_size)
  end

  # Build the next page parameters.
  def self.build_next_page_params(_collection, current_page_items, page_size = nil)
    params = {}
    params[:before_id] = current_page_items.last.id
    unless page_size.nil?
      params[:page_size] = page_size
    end
    params
  end
end
