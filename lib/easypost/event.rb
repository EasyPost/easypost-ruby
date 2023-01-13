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
  rescue EasyPost::Error => e
    unless e.status == 500
      # If the error is not a 500, re-raise it
      raise e
    end

    # API returns 500 if the payload ID is malformed, so we'll translate that to a 422
    raise EasyPost::Error.new(
      'The payload ID is invalid. Please check the ID and try again.', 422,
      'PAYLOAD.INVALID_ID',
    )
  end
end
