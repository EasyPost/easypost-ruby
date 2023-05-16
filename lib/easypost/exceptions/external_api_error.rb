# frozen_string_literal: true

class EasyPost::Exceptions::ExternalApiError < EasyPost::Exceptions::EasyPostError
  attr_reader :status_code, :code

  def initialize(message, status_code = nil, error_type = nil)
    super message
    @status_code = status_code
    @code = error_type
  end

  def pretty_print
    "#{code} (#{status_code}): #{message}"
  end
end
