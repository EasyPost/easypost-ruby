# frozen_string_literal: true

class EasyPost::Webhook < EasyPost::Resource
  def update(params = {})
    # NOTE: This method is redefined here since the "url" method conflicts
    # with the objects field
    unless id
      raise EasyPost::Error.new("Could not determine which URL to request: #{self.class} instance has invalid ID: #{id.inspect}")
    end

    instance_url = "#{self.class.url}/#{CGI.escape(id)}"

    response = EasyPost.make_request(:put, instance_url, @api_key, params)
    refresh_from(response, api_key, true)

    self
  end

  def delete
    # NOTE: This method is redefined here since the "url" method conflicts
    # with the objects field
    unless id
      raise EasyPost::Error.new("Could not determine which URL to request: #{self.class} instance has invalid ID: #{id.inspect}")
    end

    instance_url = "#{self.class.url}/#{CGI.escape(id)}"

    response = EasyPost.make_request(:delete, instance_url, @api_key)
    refresh_from(response, api_key)

    self
  end
end
