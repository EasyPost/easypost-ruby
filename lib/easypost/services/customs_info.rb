# frozen_string_literal: true

class EasyPost::Services::CustomsInfo < EasyPost::Services::Service
  MODEL_CLASS = EasyPost::Models::CustomsInfo #:nodoc:

  # Create a CustomsInfo object
  def create(params)
    wrapped_params = { customs_info: params }
    response = @client.make_request(:post, 'customs_infos', wrapped_params)

    EasyPost::InternalUtilities::Json.convert_json_to_object(response, MODEL_CLASS)
  end

  # Retrieve a CustomsInfo object
  def retrieve(id)
    response = @client.make_request(:get, "customs_infos/#{id}")

    EasyPost::InternalUtilities::Json.convert_json_to_object(response, MODEL_CLASS)
  end
end
