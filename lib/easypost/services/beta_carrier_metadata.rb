# frozen_string_literal: true

class EasyPost::Services::BetaCarrierMetadata < EasyPost::Services::Service
  # Retrieve metadata for carrier(s).
  def retrieve_carrier_metadata(carriers = [], types = [])
    path = '/metadata?'

    params = {}

    if carriers.length.positive?
      params[:carriers] = carriers.join(',')
    end

    if types.length.positive?
      params[:types] = types.join(',')
    end

    path += URI.encode_www_form(params)

    @client.make_request(:get, path, EasyPost::Models::EasyPostObject, params, 'beta').carriers
  end
end
