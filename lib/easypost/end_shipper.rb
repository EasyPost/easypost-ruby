# frozen_string_literal: true

# EndShipper objects are fully-qualified Address objects that require all parameters and get verified upon creation.
class EasyPost::EndShipper < EasyPost::Resource
  # Create an EndShipper object.
  def self.create(params = {}, api_key = nil)
    response = EasyPost.make_request(:post, url, api_key, { address: params })
    EasyPost::Util.convert_to_easypost_object(response, api_key)
  end

  # Updates (saves) an EndShipper object. This requires all parameters to be set.
  def save
    if @unsaved_values.length.positive?
      values = {}
      @unsaved_values.each { |k| values[k] = @values[k] }

      wrapped_params = { address: values }

      response = EasyPost.make_request(:put, url, @api_key, wrapped_params)
      refresh_from(response, api_key)
    end
    self
  end

  # TODO: Add support for getting the next page of end shippers when the API supports it.
end
