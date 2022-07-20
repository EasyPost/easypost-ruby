# frozen_string_literal: true

# PaymentMethod objects represent a payment method of a user.
class EasyPost::PaymentMethod < EasyPost::Resource
  # <b>DEPRECATED:</b> Please use <tt>Billing class</tt> instead.
  # Last working version v4.5.0. Removal v6.0.0.
  def self.all(api_key = nil)
    warn '[DEPRECATION] `all` is deprecated.  Please use `Billing.retrieve_payment_methods` instead.'
    EasyPost::Billing.retrieve_payment_methods(api_key)
  end
end
