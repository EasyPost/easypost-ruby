# frozen_string_literal: true

module EasyPost::InternalUtilities
  def self.to_snake_case(str)
    str.gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
       .gsub(/([a-z\d])([A-Z])/, '\1_\2')
       .downcase
  end
end

require_relative 'utilities/json'
require_relative 'utilities/system'
require_relative 'utilities/static_mapper'
