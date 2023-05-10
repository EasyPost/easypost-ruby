# frozen_string_literal: true

# The Batch service allows you to perform operations on multiple Shipments at once.
class EasyPost::Services::Batch < EasyPost::Services::Service
  # Create a Batch.
  def create(params = {})
    wrapped_params = { batch: params }

    @client.make_request(:post, 'batches', EasyPost::Models::Batch, wrapped_params)
  end

  # Create and buy a batch in one call.
  def create_and_buy(params = {})
    wrapped_params = { batch: params }

    @client.make_request(:post, 'batches/create_and_buy', EasyPost::Models::Batch, wrapped_params)
  end

  def all(params = {})
    @client.make_request(:get, 'batches', EasyPost::Models::ApiKey, params)
  end

  # Retrieve a Batch
  def retrieve(id)
    @client.make_request(:get, "batches/#{id}", EasyPost::Models::Batch)
  end

  # Buy a Batch.
  def buy(id, params = {})
    @client.make_request(:post, "batches/#{id}/buy", EasyPost::Models::Batch, params)
  end

  # Convert the label format of a Batch.
  def label(id, params = {})
    @client.make_request(:post, "batches/#{id}/label", EasyPost::Models::Batch, params)
  end

  # Remove Shipments from a Batch.
  def remove_shipments(id, params = {})
    @client.make_request(:post, "batches/#{id}/remove_shipments", EasyPost::Models::Batch, params)
  end

  # Add Shipments to a Batch.
  def add_shipments(id, params = {})
    @client.make_request(:post, "batches/#{id}/add_shipments", EasyPost::Models::Batch, params)
  end

  # Create a ScanForm for a Batch.
  def create_scan_form(id, params = {})
    @client.make_request(:post, "batches/#{id}/scan_form", EasyPost::Models::Batch, params)
  end
end
