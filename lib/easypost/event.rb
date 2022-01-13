# frozen_string_literal: true

require 'json'

class EasyPost::Event < EasyPost::Resource
  def self.receive(values)
    EasyPost::Util.convert_to_easypost_object(JSON.parse(values), nil)
  end
end
