# frozen_string_literal: true

# EasyPost Error object.
class EasyPost::Error < StandardError
  attr_reader :message, :status, :http_body, :code, :errors

  # Initialize a new EasyPost Error
  def initialize(message = nil, status = nil, code = nil, errors = nil, http_body = nil)
    @message = message
    @status = status
    @code = code
    @errors = errors
    @http_body = http_body

    super(message)
  end

  # Convert an error to a string.
  def to_s
    "#{code} (#{status}): #{message} #{errors}".strip
  end

  # Compare error properties.
  def ==(other)
    other.is_a?(EasyPost::Error) &&
      message == other.message &&
      status == other.status &&
      code == other.code &&
      errors == other.errors
  end
end
