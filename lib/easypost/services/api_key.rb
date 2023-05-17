# frozen_string_literal: true

class EasyPost::Services::ApiKey < EasyPost::Services::Service
  # Retrieve all api keys.
  def all
    @client.make_request(:get, 'api_keys', EasyPost::Models::ApiKey)
  end
end
