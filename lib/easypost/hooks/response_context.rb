# frozen_string_literal: true

class EasyPost::Hooks::ResponseContext
  attr_reader :http_status, :method, :path, :headers, :response_body,
              :request_timestamp, :response_timestamp, :request_uuid

  def initialize(http_status:, method:, path:, headers:, response_body:,
                 request_timestamp:, response_timestamp:, request_uuid:)
    @http_status = http_status
    @method = method
    @path = path
    @headers = headers
    @response_body = response_body
    @request_timestamp = request_timestamp
    @response_timestamp = response_timestamp
    @request_uuid = request_uuid

    freeze
  end
end
