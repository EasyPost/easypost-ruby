# frozen_string_literal: true

# A CarrierAccount encapsulates your credentials with the carrier.
class EasyPost::CarrierAccount < EasyPost::Resource
  # Retrieve a list of available CarrierAccount types for the authenticated User.
  def self.types
    EasyPost::CarrierType.all
  end

  # Create a CarrierAccount.
  def self.create(params = {}, api_key = nil)
    # Override the default create method to handle custom workflows
    type = params['type']

    if type.nil?
      raise EasyPost::Error.new('Must provide a type when creating a CarrierAccount')
    end

    url = select_ca_creation_endpoint(type)
    wrapped_params = {}
    wrapped_params[class_name.to_sym] = params
    response = EasyPost.make_request(:post, url, api_key, wrapped_params)
    EasyPost::Util.convert_to_easypost_object(response, api_key)
  end

  def self.select_ca_creation_endpoint(carrier_account_type)
    if EasyPost::Constants::CA_TYPES_WITH_CUSTOM_FLOWS.include?(carrier_account_type)
      "#{url}/register"
    else
      url
    end
  end

  private_class_method :select_ca_creation_endpoint
end
