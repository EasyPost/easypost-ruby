# frozen_string_literal: true

require 'json'
require 'active_support/all'

# The base class for all JSON objects in the library.
class EasyPost::Models::Object
  def initialize(data)
    @values = data
    add_properties(data)
  end

  private

  def add_properties(values)
    values.each do |key, val|
      define_singleton_method(key) { handle_value(val) } # getter
      define_singleton_method("#{key}=") { |v| handle_value(v) } # setter
    end
  end

  def handle_value(val)
    case val
    when Hash
      begin
        "EasyPost::Models::#{val['object'].capitalize}".constantize.new(val)
      rescue NameError
        EasyPost::Models::EasyPostObject.new(val)
      end
    when Array
      val.map { |item| handle_value(item) }
    else
      val
    end
  end
end

# The base class for all API objects in the library that have an ID (plus optional timestamps).
class EasyPost::Models::EasyPostObject < EasyPost::Models::Object
end
