# frozen_string_literal: true

module EasyPost::Exceptions
end

require_relative 'exceptions/easy_post_error'
require_relative 'exceptions/end_of_pagination_error'
require_relative 'exceptions/external_api_error'
require_relative 'exceptions/filtering_error'
require_relative 'exceptions/invalid_object_error'
require_relative 'exceptions/invalid_parameter_error'
require_relative 'exceptions/missing_parameter_error'
require_relative 'exceptions/signature_verification_error'
require_relative 'exceptions/api/api_error'
require_relative 'exceptions/api/connection_error'
require_relative 'exceptions/api/gateway_timeout_error'
require_relative 'exceptions/api/internal_server_error'
require_relative 'exceptions/api/invalid_request_error'
require_relative 'exceptions/api/method_not_allowed_error'
require_relative 'exceptions/api/not_found_error'
require_relative 'exceptions/api/payment_error'
require_relative 'exceptions/api/proxy_error'
require_relative 'exceptions/api/rate_limit_error'
require_relative 'exceptions/api/redirect_error'
require_relative 'exceptions/api/retry_error'
require_relative 'exceptions/api/service_unavailable_error'
require_relative 'exceptions/api/ssl_error'
require_relative 'exceptions/api/timeout_error'
require_relative 'exceptions/api/unauthorized_error'
require_relative 'exceptions/api/unknown_http_error'

