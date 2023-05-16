# frozen_string_literal: true

class EasyPost::Constants

  def self.exception_cls_from_status_code(status_code)
    case status_code
    when 0
      EasyPost::Exceptions::ConnectionError
    when 100
      EasyPost::Exceptions::UnknownHttpError
    when 101
      EasyPost::Exceptions::UnknownHttpError
    when 102
      EasyPost::Exceptions::UnknownHttpError
    when 103
      EasyPost::Exceptions::UnknownHttpError
    when 300
      EasyPost::Exceptions::RedirectError
    when 301
      EasyPost::Exceptions::RedirectError
    when 302
      EasyPost::Exceptions::RedirectError
    when 303
      EasyPost::Exceptions::RedirectError
    when 304
      EasyPost::Exceptions::RedirectError
    when 305
      EasyPost::Exceptions::RedirectError
    when 306
      EasyPost::Exceptions::RedirectError
    when 307
      EasyPost::Exceptions::RedirectError
    when 308
      EasyPost::Exceptions::RedirectError
    when 401
      EasyPost::Exceptions::UnauthorizedError
    when 402
      EasyPost::Exceptions::PaymentError
    when 403
      EasyPost::Exceptions::UnauthorizedError
    when 404
      EasyPost::Exceptions::NotFoundError
    when 405
      EasyPost::Exceptions::MethodNotAllowedError
    when 408
      EasyPost::Exceptions::TimeoutError
    when 422
      EasyPost::Exceptions::InvalidRequestError
    when 429
      EasyPost::Exceptions::RateLimitError
    when 500
      EasyPost::Exceptions::InternalServerError
    when 502
      EasyPost::Exceptions::GatewayTimeoutError
    when 503
      EasyPost::Exceptions::ServiceUnavailableError
    when 504
      EasyPost::Exceptions::GatewayTimeoutError
    else
      EasyPost::Exceptions::UnknownHttpError
    end
  end

  class ErrorMessages
    API_ERROR_DETAILS_PARSING_ERROR = 'API error details could not be parsed.'
    UNEXPECTED_HTTP_STATUS_CODE = 'Unexpected HTTP status code received: %s'
  end

end