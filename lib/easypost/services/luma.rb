# frozen_string_literal: true

class EasyPost::Services::Luma < EasyPost::Services::Service
  # Get service recommendations from Luma that meet the criteria of your ruleset.
  def get_promise(params = {})
    url = 'luma/promise'
    wrapped_params = { shipment: params }
    response = @client.make_request(:post, url, wrapped_params)

    EasyPost::InternalUtilities::Json.convert_json_to_object(response).luma_info
  end
end
