# frozen_string_literal: true

require 'json'

# Webhook Events are triggered by changes in objects you've created via the API.
class EasyPost::Event < EasyPost::Resource
  # Converts a raw webhook event into an EasyPost object.
  def self.receive(values)
    EasyPost::Util.convert_to_easypost_object(JSON.parse(values), nil)
  end

  # Retrieve all payloads for an event.
  def retrieve_all_payloads(api_key = nil)
    response = EasyPost.make_request(:get, "#{url}/payloads", api_key)
    EasyPost::Util.convert_to_easypost_object(response, api_key)
  end

  # Retrieve a specific payload for an event.
  def retrieve_payload(payload_id, api_key = nil)
    response = EasyPost.make_request(:get, "#{url}/payloads/#{payload_id}", api_key)
    EasyPost::Util.convert_to_easypost_object(response, api_key)
  end

  # Get the next page of events.
  def self.get_next_page(collection, page_size = nil)
    get_next_page_exec(method(:all), collection, collection.events, page_size)
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
