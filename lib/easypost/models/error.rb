# frozen_string_literal: true

# EasyPost Error object.
class EasyPost::Models::Error
  attr_reader :code, :field, :message

  # Initialize a new EasyPost Error
  def initialize(code, field = nil, message = nil)
    @code = code
    @field = field
    @message = message
  end

  def self.from_api_error_response(data)
    code = data['code']
    field = data['field'] || nil
    message = data['message'] || nil
    EasyPost::Models::Error.new(code, field, message)
  end
end
