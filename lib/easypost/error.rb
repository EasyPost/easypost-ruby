# frozen_string_literal: true

# EasyPost Error object.
class EasyPost::Error < StandardError
  attr_reader :message, :status, :http_body, :code, :errors

  # Initialize a new EasyPost Error
  def initialize(message = nil, status = nil, code = nil, errors = nil, http_body = nil)
    # message should be a string but can sometimes incorrectly come back as an array
    @message = message.is_a?(String) ? message : EasyPost::Error.traverse_json_element(message, [])
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

  # Recursively traverses a JSON element to extract error messages and returns them as a comma-separated string.
  def self.traverse_json_element(error_message, messages_list)
    case error_message
    when Hash
      error_message.each_value { |value| traverse_json_element(value, messages_list) }
    when Array
      error_message.each { |value| traverse_json_element(value, messages_list) }
    else
      messages_list.push(error_message.to_s)
    end

    messages_list.join(', ')
  end
end
