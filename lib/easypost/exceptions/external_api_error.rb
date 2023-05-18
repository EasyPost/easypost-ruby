# frozen_string_literal: true

class EasyPost::Exceptions::ExternalApiError < EasyPost::Exceptions::EasyPostError
  attr_reader :status_code

  def initialize(message, status_code = nil)
    super message
    @status_code = status_code
  end

  def pretty_print
    "(#{status_code}): #{message}"
  end
end
