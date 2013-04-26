module EasyPost
  class Resource < EasyPostObject
    def self.class_name
      camel = self.name.split('::')[-1]
      snake = camel[0] + camel[1..-1].gsub(/([A-Z])/, '_\1')
      return snake.downcase
    end

    def self.url
      if self.class_name == 'resource'
        raise NotImplementedError.new('Resource is an abstract class.  You should perform actions on its subclasses (Address, Shipment, etc.)')
      end
      if(self.class_name[-1] == 's')
        return "/#{CGI.escape(self.class_name.downcase)}es"
      else
        return "/#{CGI.escape(class_name.downcase)}s"
      end
    end

    def url
      unless self.id
        raise Error.new("Could not determine which URL to request: #{self.class} instance has invalid ID: #{self.id.inspect}")
      end
      return "#{self.class.url}/#{CGI.escape(id)}"
    end

    def refresh
      response, api_key = EasyPost.request(:get, url, @api_key, @retrieve_options)
      refresh_from(response, api_key)
      return self
    end

    def self.all(filters={}, api_key=nil)
      response, api_key = EasyPost.request(:get, url, api_key, filters)
      return Util.convert_to_easypost_object(response, api_key)
    end

    def self.retrieve(id, api_key=nil)
      instance = self.new(id, api_key)
      instance.refresh
      return instance
    end

    def self.create(params={}, api_key=nil)
      wrapped_params = {}
      wrapped_params[self.class_name().to_sym] = params
      response, api_key = EasyPost.request(:post, self.url, api_key, wrapped_params)
      return Util.convert_to_easypost_object(response, api_key)
    end

    def delete
      response, api_key = EasyPost.request(:delete, url, @api_key)
      refresh_from(response, api_key)
      return self
    end

    def save
      if @unsaved_values.length > 0
        values = {}
        @unsaved_values.each { |k| values[k] = @values[k] }
        response, api_key = EasyPost.request(:post, url, @api_key, values)
        refresh_from(response, api_key)
      end
      return self
    end
  end
end
