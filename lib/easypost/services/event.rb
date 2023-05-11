# frozen_string_literal: true

require 'json'

# Webhook Events are triggered by changes in objects you've created via the API.
class EasyPost::Services::Event < EasyPost::Services::Service
  MODEL_CLASS = EasyPost::Models::Event

  # Retrieve an Event object
  def retrieve(id)
    @client.make_request(:get, "events/#{id}", MODEL_CLASS)
  end

  # Retrieve all Event objects
  def all(params = {})
    @client.make_request(:get, 'events', MODEL_CLASS, params)
  end

  # Converts a raw webhook event into an EasyPost object.
  def receive(values)
    EasyPost::InternalUtilities::Json.convert_json_to_object(JSON.parse(values), EasyPost::Models::EasyPostObject)
    # EasyPost::Util.convert_to_easypost_object(JSON.parse(values), nil)
  end

  # Retrieve all payloads for an event.
  def retrieve_all_payloads(event_id)
    @client.make_request(:get, "events/#{event_id}/payloads", EasyPost::Models::Payload)
  end

  # Retrieve a specific payload for an event.
  def retrieve_payload(event_id, payload_id)
    @client.make_request(:get, "events/#{event_id}/payloads/#{payload_id}", EasyPost::Models::Payload)
  end

  # Get the next page of events.
  def get_next_page(collection, page_size = nil)
    get_next_page_exec(collection, collection.events, 'events', MODEL_CLASS, page_size)
  end
end
