# frozen_string_literal: true

# CustomsInfo service contains CustomsItem objects and all necessary information for the generation of customs forms required for international shipping.
class EasyPost::Services::CustomsInfo < EasyPost::Services::Service
  MODEL_CLASS = EasyPost::Models::CustomsInfo

  # Create a CustomsInfo object
  def create(params)
    @client.make_request(:post, 'customs_infos', MODEL_CLASS, params)
  end

  # Retrieve a CustomsInfo object
  def retrieve(id)
    @client.make_request(:get, "customs_infos/#{id}", MODEL_CLASS)
  end
end
