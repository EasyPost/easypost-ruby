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
    @client.make_request(
      :post,
      'referral_customers/payment_method',
      EasyPost::Models::EasyPostObject,
      wrapped_params,
      'beta',
    )
  end

  # Refund a ReferralCustomer Customer's wallet by a specified amount. Refund will be issued to the user's original payment method.
  # This function requires the ReferralCustomer Customer's API key.
  def refund_by_amount(amount)
    params = {
      refund_amount: amount,
    }
    @client.make_request(:post, 'referral_customers/refunds', EasyPost::Models::EasyPostObject, params, 'beta')
    # noinspection RubyMismatchedReturnType
  end

  # Refund a ReferralCustomer Customer's wallet for a specified payment log entry. Refund will be issued to the user's original payment method.
  # This function requires the ReferralCustomer Customer's API key.
  def refund_by_payment_log(payment_log_id)
    params = {
      payment_log_id: payment_log_id,
    }
    @client.make_request(:post, 'referral_customers/refunds', EasyPost::Models::EasyPostObject, params, 'beta')
  end
end
