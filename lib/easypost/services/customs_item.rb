# frozen_string_literal: true

class EasyPost::Services::CustomsItem < EasyPost::Services::Service
  MODEL_CLASS = EasyPost::Models::CustomsItem

  # Create a CustomsItem object
  def create(params)
    response = @client.make_request(:post, 'customs_items', params)

    EasyPost::InternalUtilities::Json.convert_json_to_object(response, MODEL_CLASS)
  end

  # Retrieve a CustomsItem object
  def retrieve(id)
    response = @client.make_request(:get, "customs_items/#{id}")

    EasyPost::InternalUtilities::Json.convert_json_to_object(response, MODEL_CLASS)
  end
end
