# frozen_string_literal: true

module EasyPost::InternalUtilities::Json
  def self.convert_json_to_object(data, cls = EasyPost::Models::EasyPostObject)
    data = parse_json(data) if data.is_a?(String) # Parse JSON to a Hash or Array if it's a string
    if data.is_a?(Array)
      # Deserialize array data into an array of objects
      data.map { |i| convert_json_to_object(i, cls) }
    elsif data.is_a?(Hash)
      # Deserialize hash data into a new object instance
      cls.new(data)
    else
      # data is neither a Hash nor Array (but somehow was parsed as JSON? This should never happen)
      data
    end
  end

  def self.parse_json(data)
    return if data.nil?

    JSON.parse(data)
  rescue JSON::ParserError
    data # Not JSON, return the original data (used mostly when dealing with final values like strings, booleans, etc.)
  end

  def self.http_response_is_json?(response)
    response['Content-Type'] ? response['Content-Type'].start_with?('application/json') : false
  end
end
