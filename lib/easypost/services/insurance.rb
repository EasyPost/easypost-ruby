# frozen_string_literal: true

# An Insurance service represents insurance for packages purchased both via the EasyPost API as well
# as shipments purchased through third parties and later registered with EasyPost.
class EasyPost::Services::Insurance < EasyPost::Services::Service
  MODEL_CLASS = EasyPost::Models::Insurance

  # Create an Insurance object
  def create(params = {})
    wrapped_params = { insurance: params }
    @client.make_request(:post, 'insurances', MODEL_CLASS, wrapped_params)
  end

  # Retrieve an Insurance object
  def retrieve(id)
    @client.make_request(:get, "insurances/#{id}", MODEL_CLASS)
  end

  # Retrieve all Insurance objects
  def all(params = {})
    @client.make_request(:get, 'insurances', MODEL_CLASS, params)
  end

  # Get the next page of insurances.
  def get_next_page(collection, page_size = nil)
    get_next_page_exec(collection, collection.insurances, 'insurances', MODEL_CLASS, page_size)
  end
end
