# frozen_string_literal: true

class EasyPost::Services::ScanForm < EasyPost::Services::Service
  MODEL_CLASS = EasyPost::Models::ScanForm

  # Create a ScanForm.
  def create(params = {})
    @client.make_request(:post, 'scan_forms', MODEL_CLASS, params)
  end

  # Retrieve a ScanForm.
  def retrieve(id)
    @client.make_request(:get, "scan_forms/#{id}", MODEL_CLASS)
  end

  # Retrieve a list of ScanForms
  def all(params = {})
    @client.make_request(:get, 'scan_forms', MODEL_CLASS, params)
  end

  # Get the next page of ScanForms.
  def get_next_page(collection, page_size = nil)
    get_next_page_helper(collection, collection.scan_forms, 'scan_forms', MODEL_CLASS, page_size)
  end
end
