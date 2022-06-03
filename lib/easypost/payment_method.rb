# frozen_string_literal: true

# PaymentMethod objects represent a payment method of a user.
class EasyPost::PaymentMethod < EasyPost::Resource
  # Retrieve all payment methods.
  def self.all(api_key = nil)
    response = EasyPost.make_request(:get, url, api_key)

    if response['id'].nil?
      raise EasyPost::Error.new('Billing has not been setup for this user. Please add a payment method.')
    end

    EasyPost::Util.convert_to_easypost_object(response, api_key)
  end
end
