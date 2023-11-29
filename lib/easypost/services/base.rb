# frozen_string_literal: true

require_relative '../internal_utilities'

# The base class for all services in the library.
class EasyPost::Services::Service
  def initialize(client)
    @client = client
  end

  protected

  def get_all_helper(endpoint, cls, params, filters = nil)
    response = @client.make_request(:get, endpoint, params)

    response[EasyPost::InternalUtilities::Constants::FILTERS_KEY] = filters unless filters.nil?

    EasyPost::InternalUtilities::Json.convert_json_to_object(response, cls)
  end

  def has_more_pages?(collection)
    collection&.has_more
  end
end
