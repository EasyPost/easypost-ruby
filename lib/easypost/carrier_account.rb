module EasyPost
  class CarrierAccount < Resource
    def self.types
      response = EasyPost.make_request(:get, "/carrier_types", @api_key)
      return Util.convert_to_easypost_object(response, api_key)
    end
  end
end
