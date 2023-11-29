# frozen_string_literal: true

class EasyPost::Services::Report < EasyPost::Services::Service
  MODEL_CLASS = EasyPost::Models::Report

  # Create a Report
  def create(params = {})
    unless params[:type]
      raise ArgumentError, "Missing 'type' parameter in params" # TODO: replace the error in the error-handling overhaul PR
    end

    type = params.delete(:type)
    url = "reports/#{type}"
    response = @client.make_request(:post, url, params)

    EasyPost::InternalUtilities::Json.convert_json_to_object(response, MODEL_CLASS)
  end

  # Retrieve a Report
  def retrieve(id)
    response = @client.make_request(:get, "reports/#{id}")

    EasyPost::InternalUtilities::Json.convert_json_to_object(response, MODEL_CLASS)
  end

  # Retrieve all Report objects
  def all(params = {})
    unless params[:type]
      raise ArgumentError, "Missing 'type' parameter in params" # TODO: replace the error in the error-handling overhaul PR
    end

    type = params.delete(:type)
    filters = {
      key: 'reports',
      type: type,
    }
    url = "reports/#{type}"
    response = get_all_helper(url, MODEL_CLASS, params, filters)
    response.define_singleton_method(:type) { type }

    response
  end

  # Get next page of Report objects
  def get_next_page(collection, page_size = nil)
    raise EasyPost::Errors::EndOfPaginationError.new unless has_more_pages?(collection)

    params = {
      before_id: collection.reports.last.id,
      type: (collection[EasyPost::InternalUtilities::Constants::FILTERS_KEY] || {}).fetch(:type, nil),
    }
    params[:page_size] = page_size unless page_size.nil?

    all(params)
  end
end
