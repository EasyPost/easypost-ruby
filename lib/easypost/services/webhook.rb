# frozen_string_literal: true

class EasyPost::Services::Webhook < EasyPost::Services::Service
  MODEL_CLASS = EasyPost::Models::Webhook # :nodoc:

  # Create a Webhook.
  def create(params = {})
    wrapped_params = { webhook: params }
    response = @client.make_request(:post, 'webhooks', wrapped_params)

    EasyPost::InternalUtilities::Json.convert_json_to_object(response, MODEL_CLASS)
  end

  # Retrieve a Webhook
  def retrieve(id)
    response = @client.make_request(:get, "webhooks/#{id}")

    EasyPost::InternalUtilities::Json.convert_json_to_object(response, MODEL_CLASS)
  end

  # Retrieve a list of Webhooks
  def all(params = {})
    filters = { 'key' => 'webhooks' }

    get_all_helper('webhooks', MODEL_CLASS, params, filters)
  end

  # Update a Webhook.
  def update(id, params = {})
    wrapped_params = { webhook: params }
    response = @client.make_request(:patch, "webhooks/#{id}", wrapped_params)

    EasyPost::InternalUtilities::Json.convert_json_to_object(response, MODEL_CLASS)
  end

  # Delete a Webhook.
  def delete(id)
    @client.make_request(:delete, "webhooks/#{id}")

    # Return true if succeeds, an error will be thrown if it fails
    true
  end
end
