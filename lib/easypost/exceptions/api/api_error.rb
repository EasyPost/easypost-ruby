# frozen_string_literal: true

require_relative '../easy_post_error'
require 'easypost/constants'

class EasyPost::Exceptions::ApiError < EasyPost::Exceptions::EasyPostError
  attr_reader :status_code, :code, :errors

  def initialize(message, status_code = nil, error_code = nil, sub_errors = nil)
    super message
    @status_code = status_code
    @code = error_code
    @errors = sub_errors
  end

  def pretty_print
    error_string = "#{code} (#{status_code}): #{message}"
    errors&.each do |error|
      error_string += "\nField: #{error.field}\nMessage: #{error.message}"
    end
    error_string
  end

  # Recursively traverses a JSON element to extract error messages and returns them as a comma-separated string.
  def self.collect_error_messages(error_message, messages_list)
    case error_message
    when Hash
      error_message.each_value { |value| collect_error_messages(value, messages_list) }
    when Array
      error_message.each { |value| collect_error_messages(value, messages_list) }
    else
      messages_list.push(error_message.to_s)
    end

    messages_list.join(', ')
  end

  def self.handle_api_error(response)
    status_code = response.code
    status_code = status_code.to_i if status_code.is_a?(String)

    if status_code >= 200 && status_code <= 299
      return nil
    end

    # Try to parse the response body as JSON
    begin
      error_data = JSON.parse(response.body)['error']

      error_message = error_data['message']
      error_type = error_data['code']
      errors = error_data['errors']&.map do |error|
        EasyPost::Models::Error.from_api_error_response(error)
      end
    rescue StandardError
      error_message = response.code.to_s
      error_type = EasyPost::Constants::API_ERROR_DETAILS_PARSING_ERROR
      errors = nil
    end

    cls = exception_cls_from_status_code(status_code)

    if cls == EasyPost::Exceptions::UnknownHttpError
      error_message = EasyPost::Constants::UNEXPECTED_HTTP_STATUS_CODE % status_code
      return EasyPost::Exceptions::UnknownHttpError.new(error_message, status_code, nil, nil)
    end

    # Return (don't throw here) an instance of the appropriate error class
    cls.new(error_message, status_code, error_type, errors)
  end

  def self.exception_cls_from_status_code(status_code)
    # rubocop:disable Lint/DuplicateBranch
    case status_code
    when 0
      EasyPost::Exceptions::ConnectionError
    when 100, 101, 102, 103
      EasyPost::Exceptions::UnknownHttpError
    when 300, 301, 302, 303, 304, 305, 306, 307, 308
      EasyPost::Exceptions::RedirectError
    when 401
      EasyPost::Exceptions::UnauthorizedError
    when 402
      EasyPost::Exceptions::PaymentError
    when 403
      EasyPost::Exceptions::ForbiddenError
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
    when 502, 504
      EasyPost::Exceptions::GatewayTimeoutError
    when 503
      EasyPost::Exceptions::ServiceUnavailableError
    else
      EasyPost::Exceptions::UnknownHttpError
    end
    # rubocop:enable Lint/DuplicateBranch
  end
end
