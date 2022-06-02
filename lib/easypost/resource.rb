# frozen_string_literal: true

# The Resource object is extended by each EasyPost object.
class EasyPost::Resource < EasyPost::EasyPostObject
  extend Enumerable

  # The class name of an EasyPost object.
  def self.class_name
    camel = name.split('::')[-1]
    snake = camel[0..0] + camel[1..-1].gsub(/([A-Z])/, '_\1')
    snake.downcase
  end

  # The instance url of the Resource.
  def self.url
    if class_name == 'resource'
      raise NotImplementedError.new(
        'Resource is an abstract class. You should perform actions on its subclasses (Address, Shipment, etc.)',
      )
    end

    if class_name[-1..-1] == 's' || class_name[-1..-1] == 'h'
      "/v2/#{CGI.escape(class_name.downcase)}es"
    else
      "/v2/#{CGI.escape(class_name.downcase)}s"
    end
  end

  # The url of the Resource.
  def url
    unless id
      raise EasyPost::Error.new("Could not determine which URL to request: #{self.class} instance has invalid ID: #{id.inspect}")
    end

    "#{self.class.url}/#{CGI.escape(id)}"
  end

  # Refresh an object from the API response.
  def refresh
    response = EasyPost.make_request(:get, url, @api_key, @retrieve_options)
    refresh_from(response, api_key)
    self
  end

  # Retrieve a list of EasyPost objects.
  def self.all(filters = {}, api_key = nil)
    response = EasyPost.make_request(:get, url, api_key, filters)
    EasyPost::Util.convert_to_easypost_object(response, api_key)
  end

  def self.each(filters = {}, api_key = EasyPost.api_key, &block)
    return to_enum(:each, filters, api_key) unless block_given?

    loop do
      page, has_more = all(filters, api_key).values
      last = page.each(&block).last
      break if page.empty? || !has_more

      filters[:before_id] = last.id
    end
  end

  # Retrieve an EasyPost object.
  def self.retrieve(id, api_key = nil)
    instance = new(id, api_key)
    instance.refresh
    instance
  end

  # Create an EasyPost object.
  def self.create(params = {}, api_key = nil)
    wrapped_params = {}
    wrapped_params[class_name.to_sym] = params
    response = EasyPost.make_request(:post, url, api_key, wrapped_params)
    EasyPost::Util.convert_to_easypost_object(response, api_key)
  end

  # Delete an EasyPost object.
  def delete
    response = EasyPost.make_request(:delete, url, @api_key)
    refresh_from(response, api_key)
    self
  end

  # Save (update) and EasyPost object.
  def save
    if @unsaved_values.length.positive?
      values = {}
      @unsaved_values.each { |k| values[k] = @values[k] }

      @unsaved_values.each do |key| # rubocop:disable Style/CombinableLoops
        value = values[key]
        if value.is_a?(EasyPost::EasyPostObject)
          values[key] = value.flatten_unsaved
        end
      end

      wrapped_params = { self.class.class_name => values }

      response = EasyPost.make_request(:patch, url, @api_key, wrapped_params)
      refresh_from(response, api_key)
    end
    self
  end
end
