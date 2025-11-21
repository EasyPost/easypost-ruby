# frozen_string_literal: true

class EasyPost::Services::CustomerPortal < EasyPost::Services::Service
  # Create a Portal Session
  def create_account_link(params = {})
    response = @client.make_request(:post, 'customer_portal/account_link', params)

    EasyPost::InternalUtilities::Json.convert_json_to_object(response)
  end
end
