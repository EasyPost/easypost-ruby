class EasyPost::User < EasyPost::Resource
  def self.create(params={}, api_key=nil)
    response = EasyPost.make_request(:post, self.url, api_key, {self.class_name.to_sym => params})
    return EasyPost::Util.convert_to_easypost_object(response, api_key)
  end

  def save
    if @unsaved_values.length > 0
      values = {}
      @unsaved_values.each { |k| values[k] = @values[k] }

      wrapped_params = {user: values}

      response = EasyPost.make_request(:put, url, @api_key, wrapped_params)
      refresh_from(response, api_key)
    end
    return self
  end

  def self.retrieve_me
    self.all
  end

  def self.all_api_keys
    response = EasyPost.make_request(:get, "/api_keys", @api_key)
    return EasyPost::Util.convert_to_easypost_object(response, api_key)
  end

  def api_keys
    api_keys = EasyPost::User.all_api_keys

    if api_keys.id == self.id
      my_api_keys = api_keys.keys
    else
      for child in api_keys.children
        if child.id == self.id
          my_api_keys = child.keys
          break
        end
      end
    end

    my_api_keys
  end
end
