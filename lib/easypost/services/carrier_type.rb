# frozen_string_literal: true

class EasyPost::Services::CarrierType < EasyPost::Services::Service
  MODEL_CLASS = EasyPost::Models::CarrierType

  # Retrieve all carrier types
  def all
    response = @client.make_request(:get, 'carrier_types', MODEL_CLASS)

    EasyPost::InternalUtilities::Json.convert_json_to_object(response, MODEL_CLASS)
  end
end
