# frozen_string_literal: true

# CustomsInfo service contains CustomsItem objects and all necessary information for the generation of customs forms required for international shipping.
class EasyPost::Services::CustomsItem < EasyPost::Services::Service
  # Create a CustomsItem object
  def create(params)
    @client.make_request(:post, 'customs_items', EasyPost::Models::CustomsItem, params)
  end

  # Retrieve a CustomsItem object
  def retrieve(id)
    @client.make_request(:get, "customs_items/#{id}", EasyPost::Models::CustomsItem)
  end
end
