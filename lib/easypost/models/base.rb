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
      type = EasyPost::InternalUtilities::StaticMapper::BY_TYPE[val['object']] if val['object']
      prefix = EasyPost::InternalUtilities::StaticMapper::BY_PREFIX[val['id'].split('_').first] if val['id']
      cls = type || prefix || EasyPost::Models::EasyPostObject
      cls.new(val)
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
