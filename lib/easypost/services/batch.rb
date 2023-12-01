# frozen_string_literal: true

class EasyPost::Services::Batch < EasyPost::Services::Service
  MODEL_CLASS = EasyPost::Models::Batch

  # Create a Batch.
  def create(params = {})
    wrapped_params = { batch: params }
    response = @client.make_request(:post, 'batches', wrapped_params)

    EasyPost::InternalUtilities::Json.convert_json_to_object(response, MODEL_CLASS)
  end

  def all(params = {})
    filters = { key: 'batches' }

    get_all_helper('batches', MODEL_CLASS, params, filters)
  end

  # Retrieve a Batch
  def retrieve(id)
    response = @client.make_request(:get, "batches/#{id}")

    EasyPost::InternalUtilities::Json.convert_json_to_object(response, MODEL_CLASS)
  end

  # Buy a Batch.
  def buy(id, params = {})
    response = @client.make_request(:post, "batches/#{id}/buy", params)

    EasyPost::InternalUtilities::Json.convert_json_to_object(response, MODEL_CLASS)
  end

  # Convert the label format of a Batch.
  def label(id, params = {})
    response = @client.make_request(:post, "batches/#{id}/label", params)

    EasyPost::InternalUtilities::Json.convert_json_to_object(response, MODEL_CLASS)
  end

  # Remove Shipments from a Batch.
  def remove_shipments(id, params = {})
    response = @client.make_request(:post, "batches/#{id}/remove_shipments", params)

    EasyPost::InternalUtilities::Json.convert_json_to_object(response, MODEL_CLASS)
  end

  # Add Shipments to a Batch.
  def add_shipments(id, params = {})
    response = @client.make_request(:post, "batches/#{id}/add_shipments", params)

    EasyPost::InternalUtilities::Json.convert_json_to_object(response, MODEL_CLASS)
  end

  # Create a ScanForm for a Batch.
  def create_scan_form(id, params = {})
    response = @client.make_request(:post, "batches/#{id}/scan_form", params)

    EasyPost::InternalUtilities::Json.convert_json_to_object(response, MODEL_CLASS)
  end
end
