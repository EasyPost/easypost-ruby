class EasyPost::User < EasyPost::Resource
  def self.create(params = {}, api_key = nil)
    response = EasyPost.make_request(:post, url, api_key, {class_name.to_sym => params})
    EasyPost::Util.convert_to_easypost_object(response, api_key)
  end

  def save
    if @unsaved_values.length > 0
      values = {}
      @unsaved_values.each { |k| values[k] = @values[k] }

      wrapped_params = {user: values}

      response = EasyPost.make_request(:put, url, @api_key, wrapped_params)
      refresh_from(response, api_key)
    end
    self
  end

  def self.retrieve_me
    all
  end

  def self.all_api_keys
    EasyPost::ApiKey.all
  end

  def api_keys
    api_keys = EasyPost::User.all_api_keys

    if api_keys.id == id
      my_api_keys = api_keys.keys
    else
      api_keys.children.each do |child|
        if child.id == id
          my_api_keys = child.keys
          break
        end
      end
    end

    my_api_keys
  end
  
  def update_brand(**attrs)
    brand = EasyPost::Brand.new
    data = {object: "Brand", user_id: id, **attrs}
    # Add accessors manually because there's no API to retrieve a brand
    brand.add_accessors(data.keys)
    # Assigning values with accessors defined above
    data.each do |key, val|
      brand.send("#{key}=", val)
    end
    brand.save
  end
end
