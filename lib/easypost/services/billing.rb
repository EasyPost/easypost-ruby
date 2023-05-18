# frozen_string_literal: true

require 'easypost/constants'

class EasyPost::Services::Billing < EasyPost::Services::Service
  # Get payment method info (type of the payment method and ID of the payment method)
  def self.get_payment_method_info(priority)
    payment_methods = EasyPost::Services::Billing.retrieve_payment_methods
    payment_method_map = {
      'primary' => 'primary_payment_method',
      'secondary' => 'secondary_payment_method',
    }

    payment_method_to_use = payment_method_map[priority]

    error_string = 'The chosen payment method is not valid. Please try again.'
    raise EasyPost::Exceptions::EasyPostError.new(error_string) if payment_methods[payment_method_to_use].nil?

    payment_method_id = payment_methods[payment_method_to_use]['id']

    unless payment_method_id.nil?
      if payment_method_id.start_with?('card_')
        endpoint = '/v2/credit_cards'
      elsif payment_method_id.start_with?('bank_')
        endpoint = '/v2/bank_accounts'
      else
        raise EasyPost::Exceptions::EasyPostError.new(error_string)
      end
    end

    [endpoint, payment_method_id]
  end

  # Fund your EasyPost wallet by charging your primary or secondary card on file.
  def fund_wallet(amount, priority = 'primary')
    payment_info = EasyPost::Services::Billing.get_payment_method_info(priority.downcase)
    endpoint = payment_info[0]
    payment_id = payment_info[1]

    wrapped_params = { amount: amount }
    @client.make_request(:post, "#{endpoint}/#{payment_id}/charges", EasyPost::Models::EasyPostObject, wrapped_params)

    # Return true if succeeds, an error will be thrown if it fails
    true
  end

  # Delete a payment method.
  def delete_payment_method(priority)
    payment_info = EasyPost::Services::Billing.get_payment_method_info(priority.downcase)
    endpoint = payment_info[0]
    payment_id = payment_info[1]

    @client.make_request(:delete, "#{endpoint}/#{payment_id}")

    # Return true if succeeds, an error will be thrown if it fails
    true
  end

  # Retrieve all payment methods.
  def retrieve_payment_methods
    response = @client.make_request(:get, '/v2/payment_methods')

    if response['id'].nil?
      raise EasyPost::Exceptions::InvalidObjectError.new(EasyPost::Constants::ErrorMessages::NO_PAYMENT_METHODS)
    end

    response
  end
end
