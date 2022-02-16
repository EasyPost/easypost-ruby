# frozen_string_literal: true

require 'json'

# Webhook Events are triggered by changes in objects you've created via the API.
class EasyPost::Event < EasyPost::Resource
  # Converts a raw webhook event into an EasyPost object.
  def self.receive(values)
    EasyPost::Util.convert_to_easypost_object(JSON.parse(values), nil)
  end
end
