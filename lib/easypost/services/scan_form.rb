# frozen_string_literal: true

class EasyPost::Services::ScanForm < EasyPost::Services::Service
  MODEL_CLASS = EasyPost::Models::ScanForm

  # Create a ScanForm.
  def create(params = {})
    response = @client.make_request(:post, 'scan_forms', MODEL_CLASS, params)

    EasyPost::InternalUtilities::Json.convert_json_to_object(response, MODEL_CLASS)
  end

  # Retrieve a ScanForm.
  def retrieve(id)
    response = @client.make_request(:get, "scan_forms/#{id}", MODEL_CLASS)

    EasyPost::InternalUtilities::Json.convert_json_to_object(response, MODEL_CLASS)
  end

  # Retrieve a list of ScanForms
  def all(params = {})
    filters = { key: 'scan_forms' }

    get_all_helper('scan_forms', MODEL_CLASS, params, filters)
  end

  # Get the next page of ScanForms.
  def get_next_page(collection, page_size = nil)
    raise EasyPost::Errors::EndOfPaginationError.new unless has_more_pages?(collection)

    params = { before_id: collection.scan_forms.last.id }
    params[:page_size] = page_size unless page_size.nil?

    all(params)
  end
end
