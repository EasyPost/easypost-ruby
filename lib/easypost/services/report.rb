# frozen_string_literal: true

class EasyPost::Services::Report < EasyPost::Services::Service
  MODEL_CLASS = EasyPost::Models::Report # :nodoc:

  # Create a Report
  def create(params = {})
    unless params[:type]
      raise EasyPost::Errors::MISSING_REQUIRED_PARAMETER.new('type')
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
      raise EasyPost::Errors::MISSING_REQUIRED_PARAMETER.new('type')
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
    raise EasyPost::Errors::EndOfPaginationError.new unless more_pages?(collection)

    params = { before_id: collection.reports.last.id }
    params[:page_size] = page_size unless page_size.nil?
    params.merge!(collection[EasyPost::InternalUtilities::Constants::FILTERS_KEY]).delete(:key)

    all(params)
  end
end
