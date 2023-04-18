# frozen_string_literal: true

# A CarrierMetadata object contains all the selected metadata for all selected carriers.
class EasyPost::Beta::CarrierMetadata < EasyPost::Resource
  # Retrieve metadata for carrier(s).
  def self.retrieve_carrier_metadata(carriers = [], types = [], api_key = nil)
    path = '/beta/metadata?'

    params = {}

    if carriers.length.positive?
      params[:carriers] = carriers.join(',')
    end

    if types.length.positive?
      params[:types] = types.join(',')
    end

    # urlencoded params
    path += URI.encode_www_form(params)

    response = EasyPost.make_request(:get, path, api_key, params)
    EasyPost::Util.convert_to_easypost_object(response['carriers'], api_key)
  end
end
