# frozen_string_literal: true

# Credit card object that user can fund or delete
class EasyPost::CreditCard < EasyPost::Resource
  # Fund your EasyPost wallet by charging your primary or secondary card on file.
  def self.fund(amount, primary_or_secondary = 'primary', api_key = nil)
    payment_methods = EasyPost::PaymentMethod.all
    payment_method_map = {
      'primary' => 'primary_payment_method',
      'secondary' => 'secondary_payment_method',
    }

    payment_method_to_use = payment_method_map[primary_or_secondary]
    card_id = payment_method_to_use ? payment_methods[payment_method_to_use]['id'] : nil

    if payment_method_to_use.nil? || card_id.nil? || !card_id.start_with?('card_')
      raise EasyPost::Error.new('The chosen payment method is not a credit card. Please try again.')
    end

    wrapped_params = { amount: amount }
    response = EasyPost.make_request(:post, "#{url}/#{card_id}/charges", api_key, wrapped_params)
    EasyPost::Util.convert_to_easypost_object(response, api_key)
  end

  # Delete a credit card by ID.
  def self.delete(credit_card_id, api_key = nil)
    response = EasyPost.make_request(:delete, "#{url}/#{credit_card_id}", api_key)
    EasyPost::Util.convert_to_easypost_object(response, api_key)
  end
end
