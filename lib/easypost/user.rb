# frozen_string_literal: true

# The User object can be used to manage your own account and to create child accounts.
class EasyPost::User < EasyPost::Resource
  # Create a child User.
  def self.create(params = {}, api_key = nil)
    response = EasyPost.make_request(:post, url, api_key, { class_name.to_sym => params })
    EasyPost::Util.convert_to_easypost_object(response, api_key)
  end

  # Save (update) a User.
  def save
    if @unsaved_values.length.positive?
      values = {}
      @unsaved_values.each { |k| values[k] = @values[k] }

      wrapped_params = { user: values }

      response = EasyPost.make_request(:patch, url, @api_key, wrapped_params)
      refresh_from(response, api_key)
    end
    self
  end

  # Delete a User.
  def delete
    EasyPost.make_request(:delete, url, @api_key)
    self
  end

  # Retrieve the authenticated User.
  def self.retrieve_me
    all
  end

  # Retrieve a list of ApiKey objects.
  def self.all_api_keys
    EasyPost::ApiKey.all
  end

  # Retrieve a list of ApiKey objects of a child User.
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

  # Update the Brand of a User.
  def update_brand(**attrs)
    brand = EasyPost::Brand.new
    data = { object: 'Brand', user_id: id, **attrs }
    # Add accessors manually because there's no API to retrieve a brand
    brand.add_accessors(data.keys)
    # Assigning values with accessors defined above
    data.each do |key, val|
      brand.send("#{key}=", val)
    end
    brand.save
  end
end
