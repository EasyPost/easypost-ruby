# frozen_string_literal: true

require_relative 'api_error'

class EasyPost::Errors::RateLimitError < EasyPost::Errors::ApiError
end
