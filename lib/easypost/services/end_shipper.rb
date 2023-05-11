# frozen_string_literal: true

# EndShipper objects are fully-qualified Address objects that require all parameters and get verified upon creation.
class EasyPost::Services::EndShipper < EasyPost::Services::Service
  MODEL_CLASS = EasyPost::Models::EndShipper

  # Create an EndShipper object.
  def create(params = {})
    wrapped_params = { address: params }

    @client.make_request(:post, 'end_shippers', MODEL_CLASS, wrapped_params)
  end

  # Retrieve an EndShipper object.
  def retrieve(id)
    @client.make_request(:get, "end_shippers/#{id}", MODEL_CLASS)
  end

  # Retrieve all EndShipper objects.
  def all(params = {})
    @client.make_request(:get, 'end_shippers', MODEL_CLASS, params)
  end

  # Updates an EndShipper object. This requires all parameters to be set.
  def update(id, params)
    wrapped_params = { address: params }

    @client.make_request(:put, "end_shippers/#{id}", MODEL_CLASS, wrapped_params)
  end

  # TODO: Add support for getting the next page of end shippers when the API supports it.
end
