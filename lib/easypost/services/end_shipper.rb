# frozen_string_literal: true

class EasyPost::Services::EndShipper < EasyPost::Services::Service
  MODEL_CLASS = EasyPost::Models::EndShipper #:nodoc:

  # Create an EndShipper object.
  def create(params = {})
    wrapped_params = { address: params }
    response = @client.make_request(:post, 'end_shippers', wrapped_params)

    EasyPost::InternalUtilities::Json.convert_json_to_object(response, MODEL_CLASS)
  end

  # Retrieve an EndShipper object.
  def retrieve(id)
    response = @client.make_request(:get, "end_shippers/#{id}")

    EasyPost::InternalUtilities::Json.convert_json_to_object(response, MODEL_CLASS)
  end

  # Retrieve all EndShipper objects.
  def all(params = {})
    response = @client.make_request(:get, 'end_shippers', params)

    EasyPost::InternalUtilities::Json.convert_json_to_object(response, MODEL_CLASS)
  end

  # Updates an EndShipper object. This requires all parameters to be set.
  def update(id, params)
    wrapped_params = { address: params }
    response = @client.make_request(:put, "end_shippers/#{id}", wrapped_params)

    EasyPost::InternalUtilities::Json.convert_json_to_object(response, MODEL_CLASS)
  end

  # TODO: Add support for getting the next page of end shippers when the API supports it.
end
