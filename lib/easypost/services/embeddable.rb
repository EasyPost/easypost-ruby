# frozen_string_literal: true

class EasyPost::Services::Embeddable < EasyPost::Services::Service
  # Create an Embeddable Session
  def create_session(params = {})
    response = @client.make_request(:post, 'embeddables/session', params)

    EasyPost::InternalUtilities::Json.convert_json_to_object(response)
  end
end
