# frozen_string_literal: true

class EasyPost::Services::Parcel < EasyPost::Services::Service
  MODEL_CLASS = EasyPost::Models::Parcel # :nodoc:

  # Create a Parcel object
  def create(params = {})
    wrapped_params = { parcel: params }
    response = @client.make_request(:post, 'parcels', wrapped_params)

    EasyPost::InternalUtilities::Json.convert_json_to_object(response, MODEL_CLASS)
  end

  # Retrieve a Parcel object
  def retrieve(id)
    response = @client.make_request(:get, "parcels/#{id}")

    EasyPost::InternalUtilities::Json.convert_json_to_object(response, MODEL_CLASS)
  end
end
