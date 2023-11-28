# frozen_string_literal: true

class EasyPost::Services::Batch < EasyPost::Services::Service
  MODEL_CLASS = EasyPost::Models::Batch

  # Create a Batch.
  def create(params = {})
    wrapped_params = { batch: params }
    response = @client.make_request(:post, 'batches', MODEL_CLASS, wrapped_params)

    EasyPost::InternalUtilities::Json.convert_json_to_object(response, MODEL_CLASS)
  end

  # Create and buy a batch in one call.
  def create_and_buy(params = {})
    wrapped_params = { batch: params }
    response = @client.make_request(:post, 'batches/create_and_buy', MODEL_CLASS, wrapped_params)

    EasyPost::InternalUtilities::Json.convert_json_to_object(response, MODEL_CLASS)
  end

  def all(params = {})
    filters = { 'key' => 'batches' }

    get_all_helper('batches', MODEL_CLASS, params, filters)
  end

  # Retrieve a Batch
  def retrieve(id)
    response = @client.make_request(:get, "batches/#{id}", MODEL_CLASS)

    EasyPost::InternalUtilities::Json.convert_json_to_object(response, MODEL_CLASS)
  end

  # Buy a Batch.
  def buy(id, params = {})
    response = @client.make_request(:post, "batches/#{id}/buy", MODEL_CLASS, params)

    EasyPost::InternalUtilities::Json.convert_json_to_object(response, MODEL_CLASS)
  end

  # Convert the label format of a Batch.
  def label(id, params = {})
    response = @client.make_request(:post, "batches/#{id}/label", MODEL_CLASS, params)

    EasyPost::InternalUtilities::Json.convert_json_to_object(response, MODEL_CLASS)
  end

  # Remove Shipments from a Batch.
  def remove_shipments(id, params = {})
    response = @client.make_request(:post, "batches/#{id}/remove_shipments", MODEL_CLASS, params)

    EasyPost::InternalUtilities::Json.convert_json_to_object(response, MODEL_CLASS)
  end

  # Add Shipments to a Batch.
  def add_shipments(id, params = {})
    response = @client.make_request(:post, "batches/#{id}/add_shipments", MODEL_CLASS, params)

    EasyPost::InternalUtilities::Json.convert_json_to_object(response, MODEL_CLASS)
  end

  # Create a ScanForm for a Batch.
  def create_scan_form(id, params = {})
    response = @client.make_request(:post, "batches/#{id}/scan_form", MODEL_CLASS, params)

    EasyPost::InternalUtilities::Json.convert_json_to_object(response, MODEL_CLASS)
  end
end
