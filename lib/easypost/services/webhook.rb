# frozen_string_literal: true

# Webhook service contains the url which EasyPost will notify whenever an object in our system updates. Several types of objects are processed
# asynchronously in the EasyPost system, so whenever an object updates, an Event is sent via HTTP POST to each configured webhook URL.
class EasyPost::Services::Webhook < EasyPost::Services::Service
  MODEL_CLASS = EasyPost::Models::Webhook

  # Create a Webhook.
  def create(params = {})
    wrapped_params = { webhook: params }
    @client.make_request(:post, 'webhooks', MODEL_CLASS, wrapped_params)
  end

  # Retrieve a Webhook
  def retrieve(id)
    @client.make_request(:get, "webhooks/#{id}", MODEL_CLASS)
  end

  # Retrieve a list of Webhooks
  def all(params = {})
    @client.make_request(:get, 'webhooks', MODEL_CLASS, params)
  end

  # Update a Webhook.
  def update(id, params = {})
    @client.make_request(:patch, "webhooks/#{id}", MODEL_CLASS, params)
  end

  # Delete a Webhook.
  def delete(id)
    @client.make_request(:delete, "webhooks/#{id}")
  end
end
