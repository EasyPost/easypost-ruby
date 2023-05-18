# frozen_string_literal: true

module EasyPost::InternalUtilities
  # Convert a string to snake case
  def self.to_snake_case(str)
    str.gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
       .gsub(/([a-z\d])([A-Z])/, '\1_\2')
       .downcase
  end

  # Form-encode a multi-layer dictionary to a one-layer dictionary.
  def self.form_encode_params(hash, parent_keys = [], parent_dict = {})
    result = parent_dict or {}
    keys = parent_keys or []

    hash.each do |key, value|
      if value.instance_of?(Hash)
        keys << key
        result = form_encode_params(value, keys, result)
      else
        dict_key = build_dict_key(keys + [key])
        result[dict_key] = value
      end
    end
    result
  end

  # Build a dict key from a list of keys.
  # Example: [code, number] -> code[number]
  def self.build_dict_key(keys)
    result = keys[0].to_s

    keys[1..].each do |key|
      result += "[#{key}]"
    end

    result
  end

  # Converts an object to an object ID.
  def self.objects_to_ids(obj)
    case obj
    when EasyPost::Models::EasyPostObject
      { id: obj.id }
    when Hash
      result = {}
      obj.each { |k, v| result[k] = objects_to_ids(v) unless v.nil? }
      result
    when Array
      obj.map { |v| objects_to_ids(v) }
    else
      obj
    end
  end

  # Normalizes a list of strings.
  def self.normalize_string_list(lst)
    lst = lst.is_a?(String) ? lst.split(',') : Array(lst)
    lst.map(&:to_s).map(&:downcase).map(&:strip)
  end
end

require_relative 'utilities/json'
require_relative 'utilities/system'
require_relative 'utilities/static_mapper'
require_relative 'utilities/constants'
