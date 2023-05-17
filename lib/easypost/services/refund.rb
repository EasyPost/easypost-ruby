# frozen_string_literal: true

class EasyPost::Services::Refund < EasyPost::Services::Service
  MODEL_CLASS = EasyPost::Models::Refund

  # Create a Refund object
  def create(params = {})
    wrapped_params = { refund: params }
    @client.make_request(:post, 'refunds', MODEL_CLASS, wrapped_params)
  end

  # Retrieve a Refund object
  def retrieve(id)
    @client.make_request(:get, "refunds/#{id}", MODEL_CLASS)
  end

  # Retrieve all Refund objects
  def all(params = {})
    @client.make_request(:get, 'refunds', MODEL_CLASS, params)
  end

  # Get the next page of refunds
  def get_next_page(collection, page_size = nil)
    get_next_page_helper(collection, collection.refunds, 'refunds', MODEL_CLASS, page_size)
  end
end
