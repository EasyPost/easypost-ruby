# frozen_string_literal: true

class EasyPost::Services::Rate < EasyPost::Services::Service
  # Retrieve a Rate
  def retrieve(id)
    response = @client.make_request(:get, "rates/#{id}")

    EasyPost::InternalUtilities::Json.convert_json_to_object(response, EasyPost::Models::Rate)
  end
end
