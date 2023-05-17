# frozen_string_literal: true

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
