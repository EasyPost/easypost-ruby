# frozen_string_literal: true

class EasyPost::Hooks::RequestContext
  attr_reader :method, :path, :headers, :request_body, :request_timestamp, :request_uuid

  def initialize(method:, path:, headers:, request_body:, request_timestamp:, request_uuid:)
    @method = method
    @path = path
    @headers = headers
    @request_body = request_body
    @request_timestamp = request_timestamp
    @request_uuid = request_uuid

    freeze
  end
end
