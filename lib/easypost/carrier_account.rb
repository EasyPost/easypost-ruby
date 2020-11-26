class EasyPost::CarrierAccount < EasyPost::Resource
  def self.types
    response = EasyPost.make_request(:get, "/carrier_types", @api_key)
    return EasyPost::Util.convert_to_easypost_object(response, api_key)
  end
end
