# frozen_string_literal: true

require_relative 'api_error'

class EasyPost::Exceptions::RateLimitError < EasyPost::Exceptions::ApiError
end
