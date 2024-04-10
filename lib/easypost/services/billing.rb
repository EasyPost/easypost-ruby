# frozen_string_literal: true

require 'easypost/constants'

class EasyPost::Services::Billing < EasyPost::Services::Service
  # Fund your EasyPost wallet by charging your primary or secondary card on file.
  def fund_wallet(amount, priority = 'primary')
    payment_info = get_payment_method_info(priority.downcase)
    endpoint = payment_info[0]
    payment_id = payment_info[1]

    wrapped_params = { amount: amount }
    @client.make_request(:post, "#{endpoint}/#{payment_id}/charges", wrapped_params)

    # Return true if succeeds, an error will be thrown if it fails
    true
  end

  # Delete a payment method.
  def delete_payment_method(priority)
    payment_info = get_payment_method_info(priority.downcase)
    endpoint = payment_info[0]
    payment_id = payment_info[1]

    @client.make_request(:delete, "#{endpoint}/#{payment_id}")

    # Return true if succeeds, an error will be thrown if it fails
    true
  end

  # Retrieve all payment methods.
  def retrieve_payment_methods
    response = @client.make_request(:get, '/payment_methods')
    payment_methods = EasyPost::InternalUtilities::Json.convert_json_to_object(response)

    if payment_methods['id'].nil?
      raise EasyPost::Errors::InvalidObjectError.new(EasyPost::Constants::NO_PAYMENT_METHODS)
    end

    payment_methods
  end

  private

  # Get payment method info (type of the payment method and ID of the payment method)
  def get_payment_method_info(priority)
    payment_methods = retrieve_payment_methods
    payment_method_map = {
      'primary' => 'primary_payment_method',
      'secondary' => 'secondary_payment_method',
    }

    payment_method_to_use = payment_method_map[priority]

    error_string = EasyPost::Constants::INVALID_PAYMENT_METHOD
    suggestion = "Please use a valid payment method: #{payment_method_map.keys.join(', ')}"
    if payment_methods[payment_method_to_use].nil?
      raise EasyPost::Errors::InvalidParameterError.new(
        error_string,
        suggestion,
      )
    end

    payment_method_id = payment_methods[payment_method_to_use]['id']
    payment_method_object_type = payment_methods[payment_method_to_use]['object']

    if payment_method_object_type == 'CreditCard'

      endpoint = '/credit_cards'
    elsif payment_method_object_type == 'BankAccount'
      endpoint = '/bank_accounts'
    else
      raise EasyPost::Errors::InvalidObjectError.new(error_string)
    end

    [endpoint, payment_method_id]
  end
end
