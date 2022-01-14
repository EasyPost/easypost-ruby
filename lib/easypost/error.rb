# frozen_string_literal: true

class EasyPost::Error < StandardError
  attr_reader :message, :status, :http_status, :http_body, :code, :errors

  def initialize(message = nil, status = nil, code = nil, errors = nil, http_body = nil)
    @message = message
    @status = status
    @http_status = status # deprecated
    @code = code
    @errors = errors
    @http_body = http_body

    super(message)
  end

  def to_s
    "#{code} (#{status}): #{message} #{errors}".strip
  end

  def ==(other)
    other.is_a?(EasyPost::Error) &&
      message == other.message &&
      status == other.status &&
      code == other.code &&
      errors == other.errors
  end
end
