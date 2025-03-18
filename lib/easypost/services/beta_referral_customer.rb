# frozen_string_literal: true

class EasyPost::Services::BetaReferralCustomer < EasyPost::Services::Service
  # Add a Stripe payment method to a ReferralCustomer Customer. This function requires the ReferralCustomer Customer's API key.
  def add_payment_method(stripe_customer_id, payment_method_reference, priority = 'primary')
    wrapped_params = {
      payment_method: {
        stripe_customer_id: stripe_customer_id,
        payment_method_reference: payment_method_reference,
        priority: priority.downcase,
      },
    }
    response = @client.make_request(
      :post,
      'referral_customers/payment_method',
      wrapped_params,
      'beta',
    )

    EasyPost::InternalUtilities::Json.convert_json_to_object(response)
  end

  # Refund a ReferralCustomer Customer's wallet by a specified amount. Refund will be issued to the user's original payment method.
  # This function requires the ReferralCustomer Customer's API key.
  def refund_by_amount(amount)
    params = {
      refund_amount: amount,
    }
    response = @client.make_request(:post, 'referral_customers/refunds', params, 'beta')

    EasyPost::InternalUtilities::Json.convert_json_to_object(response)
  end

  # Refund a ReferralCustomer Customer's wallet for a specified payment log entry. Refund will be issued to the user's original payment method.
  # This function requires the ReferralCustomer Customer's API key.
  def refund_by_payment_log(payment_log_id)
    params = {
      payment_log_id: payment_log_id,
    }
    response = @client.make_request(:post, 'referral_customers/refunds', params, 'beta')

    EasyPost::InternalUtilities::Json.convert_json_to_object(response)
  end

  # Creates a client secret to use with Stripe when adding a credit card.
  def create_credit_card_client_secret()
    response = @client.make_request(:post, 'setup_intents', nil, 'beta')

    EasyPost::InternalUtilities::Json.convert_json_to_object(response)
  end

  # Creates a client secret to use with Stripe when adding a bank account.
  def create_bank_account_client_secret(return_url = nil)
    params = return_url ? { return_url: return_url } : nil
    response = @client.make_request(:post, 'financial_connections_sessions', params, 'beta')

    EasyPost::InternalUtilities::Json.convert_json_to_object(response)
  end
end
