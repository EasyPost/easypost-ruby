# frozen_string_literal: true

# Billing class that users can manage their payment and fund
class EasyPost::Billing < EasyPost::Resource
  class << self
    protected

    # Get payment method info (type of the payment method and ID of the payment method)
    def get_payment_method_info(primary_or_secondary)
      payment_methods = EasyPost::Billing.retrieve_payment_methods
      payment_method_map = {
        'primary' => 'primary_payment_method',
        'secondary' => 'secondary_payment_method',
      }

      payment_method_to_use = payment_method_map[primary_or_secondary]

      error_string = 'The chosen payment method is not valid. Please try again.'
      raise EasyPost::Error.new(error_string) if payment_methods[payment_method_to_use].nil?

      payment_method_id = payment_methods[payment_method_to_use]['id']

      unless payment_method_id.nil?
        if payment_method_id.start_with?('card_')
          endpoint = '/v2/credit_cards'
        elsif payment_method_id.start_with?('bank_')
          endpoint = '/v2/bank_accounts'
        else
          raise EasyPost::Error.new(error_string)
        end
      end

      [endpoint, payment_method_id]
    end
  end

  # Fund your EasyPost wallet by charging your primary or secondary card on file.
  def self.fund_wallet(amount, primary_or_secondary = 'primary', api_key = nil)
    payment_info = get_payment_method_info(primary_or_secondary.downcase)
    endpoint = payment_info[0]
    payment_id = payment_info[1]

    wrapped_params = { amount: amount }
    EasyPost.make_request(:post, "#{endpoint}/#{payment_id}/charges", api_key, wrapped_params)

    # Return true if succeeds, an error will be thrown if it fails
    true
  end

  # Delete a payment method.
  def self.delete_payment_method(primary_or_secondary, api_key = nil)
    payment_info = get_payment_method_info(primary_or_secondary.downcase)
    endpoint = payment_info[0]
    payment_id = payment_info[1]

    EasyPost.make_request(:delete, "#{endpoint}/#{payment_id}", api_key)

    # Return true if succeeds, an error will be thrown if it fails
    true
  end

  # Retrieve all payment methods.
  def self.retrieve_payment_methods(api_key = nil)
    response = EasyPost.make_request(:get, '/v2/payment_methods', api_key)

    if response['id'].nil?
      raise EasyPost::Error.new('Billing has not been setup for this user. Please add a payment method.')
    end

    EasyPost::Util.convert_to_easypost_object(response, api_key)
  end
end
