# frozen_string_literal: true

# CustomsInfo service contains CustomsItem objects and all necessary information for the generation of customs forms required for international shipping.
class EasyPost::Services::CustomsItem < EasyPost::Services::Service
  MODEL_CLASS = EasyPost::Models::CustomsItem

  # Create a CustomsItem object
  def create(params)
    @client.make_request(:post, 'customs_items', MODEL_CLASS, params)
  end

  # Retrieve a CustomsItem object
  def retrieve(id)
    @client.make_request(:get, "customs_items/#{id}", MODEL_CLASS)
  end
end
