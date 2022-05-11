# frozen_string_literal: true

# EndShipper objects are fully-qualified Address objects that require all parameters and get verified upon creation.
class EasyPost::Beta::EndShipper < EasyPost::Resource
  # Create an EndShipper object.
  def self.create(params = {}, api_key = nil)
    response = EasyPost.make_request(:post, '/beta/end_shippers', api_key, { address: params })
    EasyPost::Util.convert_to_easypost_object(response, api_key)
  end

  # Retrieves an EndShipper object.
  def self.retrieve(id, params = {}, api_key = nil)
    response = EasyPost.make_request(:get, "/beta/end_shippers/#{id}", api_key, params)
    EasyPost::Util.convert_to_easypost_object(response, api_key)
  end

  # Retrieves a list of EndShipper objects.
  def self.all(params = {}, api_key = nil)
    response = EasyPost.make_request(:get, '/beta/end_shippers', api_key, params)
    EasyPost::Util.convert_to_easypost_object(response, api_key)
  end

  # Updates (saves) an EndShipper object. This requires all parameters to be set.
  def save
    if @unsaved_values.length.positive?
      values = {}
      @unsaved_values.each { |k| values[k] = @values[k] }

      wrapped_params = { address: values }

      response = EasyPost.make_request(:put, "/beta/end_shippers/#{id}", @api_key, wrapped_params)
      refresh_from(response, api_key)
    end
    self
  end
end
