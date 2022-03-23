# frozen_string_literal: true

# A Report contains a csv that is a log of all the objects created within a certain time frame.
class EasyPost::Report < EasyPost::Resource
  # Create a Report.
  def self.create(params = {}, api_key = nil)
    url = "#{self.url}/#{params[:type]}"

    wrapped_params = {}
    wrapped_params[class_name.to_sym] = params

    response = EasyPost.make_request(:post, url, api_key, params)
    EasyPost::Util.convert_to_easypost_object(response, api_key)
  end

  # Retrieve a list of Report objects.
  def self.all(filters = {}, api_key = nil)
    url = "#{self.url}/#{filters[:type]}"

    response = EasyPost.make_request(:get, url, api_key, filters)
    EasyPost::Util.convert_to_easypost_object(response, api_key)
  end
end
