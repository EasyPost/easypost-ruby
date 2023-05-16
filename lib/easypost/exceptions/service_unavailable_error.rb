# frozen_string_literal: true

require_relative 'api_error'

class EasyPost::Exceptions::ServiceUnavailableError < EasyPost::Exceptions::ApiError
  def initialize(message, status_code = nil, error_type = nil, errors = nil)
    super message, status_code, error_type, errors
  end
end
