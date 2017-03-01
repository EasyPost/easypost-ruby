module EasyPost
  class Webhook < Resource
    def update(params={})
      unless self.id
        raise Error.new("Could not determine which URL to request: #{self.class} instance has invalid ID: #{self.id.inspect}")
      end
      instance_url = "#{self.class.url}/#{CGI.escape(id)}"

      response, api_key = EasyPost.request(:put, instance_url, @api_key, params)
      self.refresh_from(response, api_key, true)

      return self
    end

    def delete
      # Note: This method is redefined here since the "url" method conflicts with the objects field
      unless self.id
        raise Error.new("Could not determine which URL to request: #{self.class} instance has invalid ID: #{self.id.inspect}")
      end
      instance_url = "#{self.class.url}/#{CGI.escape(id)}"

      response, api_key = EasyPost.request(:delete, instance_url, @api_key)
      refresh_from(response, api_key)

      return self
    end
  end
end
