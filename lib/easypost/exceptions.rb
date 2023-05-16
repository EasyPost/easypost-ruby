# frozen_string_literal: true

module EasyPost::Exceptions
end

require_relative 'exceptions/api_error'
require_relative 'exceptions/connection_error'
require_relative 'exceptions/easy_post_error'
require_relative 'exceptions/gateway_timeout_error'
require_relative 'exceptions/internal_server_error'
require_relative 'exceptions/invalid_request_error'
require_relative 'exceptions/method_not_allowed_error'
require_relative 'exceptions/not_found_error'
require_relative 'exceptions/payment_error'
require_relative 'exceptions/proxy_error'
require_relative 'exceptions/rate_limit_error'
require_relative 'exceptions/redirect_error'
require_relative 'exceptions/retry_error'
require_relative 'exceptions/service_unavailable_error'
require_relative 'exceptions/ssl_error'
require_relative 'exceptions/timeout_error'
require_relative 'exceptions/unauthorized_error'
require_relative 'exceptions/unknown_http_error'
