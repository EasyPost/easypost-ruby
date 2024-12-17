# frozen_string_literal: true

require 'json'

class EasyPost::Services::Event < EasyPost::Services::Service
  MODEL_CLASS = EasyPost::Models::Event #:nodoc:

  # Retrieve an Event object
  def retrieve(id)
    response = @client.make_request(:get, "events/#{id}")

    EasyPost::InternalUtilities::Json.convert_json_to_object(response, MODEL_CLASS)
  end

  # Retrieve all Event objects
  def all(params = {})
    filters = { key: 'events' }

    get_all_helper('events', MODEL_CLASS, params, filters)
  end

  # Retrieve all payloads for an event.
  def retrieve_all_payloads(event_id)
    response = @client.make_request(:get, "events/#{event_id}/payloads")

    EasyPost::InternalUtilities::Json.convert_json_to_object(response, EasyPost::Models::Payload)
  end

  # Retrieve a specific payload for an event.
  def retrieve_payload(event_id, payload_id)
    response = @client.make_request(:get, "events/#{event_id}/payloads/#{payload_id}")

    EasyPost::InternalUtilities::Json.convert_json_to_object(response, EasyPost::Models::Payload)
  end

  # Get the next page of events.
  def get_next_page(collection, page_size = nil)
    raise EasyPost::Errors::EndOfPaginationError.new unless more_pages?(collection)

    params = { before_id: collection.events.last.id }
    params[:page_size] = page_size unless page_size.nil?

    all(params)
  end
end
