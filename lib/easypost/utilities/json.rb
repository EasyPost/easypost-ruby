# frozen_string_literal: true

module EasyPost::InternalUtilities::Json
  def self.convert_json_to_object(data, cls, sub_key = nil)
    data = JSON.parse(data) if data.is_a?(String) # Parse JSON to a Hash or Array if it's a string
    if data.is_a?(Array)
      # Deserialize array data into an array of objects
      data.map { |i| convert_json_to_object(i, cls, nil) } # we don't use sub_key on arrays
    elsif data.is_a?(Hash)
      if sub_key
        data = data[sub_key] # If a sub_key is specified, use that key's value as the data
      end
      # Deserialize hash data into a new object instance
      cls.new(data)
    else
      # data is neither a Hash nor Array (but somehow was parsed as JSON? This should never happen)
      data
    end
  rescue JSON::ParserError
    data # Not JSON, return the original data (used mostly when dealing with final values like strings, booleans, etc.)
  end

  def self.http_response_is_json?(response)
    response['Content-Type'] ? response['Content-Type'].start_with?('application/json') : false
  end
end
