# frozen_string_literal: true

class EasyPost::Services::Rate < EasyPost::Services::Service
  # Retrieve a Rate
  def retrieve(id)
    @client.make_request(:get, "rates/#{id}", EasyPost::Models::Rate)
  end
end
