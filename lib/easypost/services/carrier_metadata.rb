# frozen_string_literal: true

class EasyPost::Services::CarrierMetadata < EasyPost::Services::Service
  # Retrieve metadata for carrier(s).
  def retrieve(carriers = [], types = [])
    path = '/metadata/carriers?'

    params = {}

    if carriers.length.positive?
      params[:carriers] = carriers.join(',')
    end

    if types.length.positive?
      params[:types] = types.join(',')
    end

    path += URI.encode_www_form(params)

    @client.make_request(:get, path, EasyPost::Models::EasyPostObject, params).carriers
  end
end
