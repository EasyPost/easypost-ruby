# frozen_string_literal: true

class EasyPost::Errors::ExternalApiError < EasyPost::Errors::EasyPostError
  attr_reader :status_code

  def initialize(message, status_code = nil)
    super message
    @status_code = status_code
  end

  def pretty_print
    if status_code.nil?
      return message
    end

    "(#{status_code}): #{message}"
  end
end
