# frozen_string_literal: true

# CustomsInfo service contains CustomsItem objects and all necessary information for the generation of customs forms required for international shipping.
class EasyPost::Services::CustomsInfo < EasyPost::Services::Service
  # Create a CustomsInfo object
  def create(params)
    @client.make_request(:post, 'customs_infos', EasyPost::Models::CustomsInfo, params)
  end

  # Retrieve a CustomsInfo object
  def retrieve(id)
    @client.make_request(:get, "customs_infos/#{id}", EasyPost::Models::CustomsInfo)
  end
end
