# frozen_string_literal: true

class EasyPost::Services::CarrierType < EasyPost::Services::Service
  MODEL_CLASS = EasyPost::Models::CarrierType

  # Retrieve all carrier types
  def all
    @client.make_request(:get, 'carrier_types', MODEL_CLASS)
  end
end
