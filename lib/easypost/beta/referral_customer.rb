# frozen_string_literal: true

# ReferralCustomer objects are User objects created from a Partner user.
class EasyPost::Beta::ReferralCustomer < EasyPost::Resource
  class << self
    protected

    # Retrieve EasyPost's Stripe public API key.
    def retrieve_easypost_stripe_api_key
      response = EasyPost.make_request(:get, '/beta/partners/stripe_public_key', @api_key)
      response['public_key']
    end

    # Get credit card token from Stripe.
    def create_stripe_token(number, expiration_month, expiration_year,
                            cvc, easypost_stripe_token)
      headers = {
        # This Stripe endpoint only accepts URL form encoded bodies.
        Authorization: "Bearer #{easypost_stripe_token}",
        'Content-type': 'application/x-www-form-urlencoded',
      }

      credit_card_hash = {
        card: {
          number: number,
          exp_month: expiration_month,
          exp_year: expiration_year,
          cvc: cvc,
        },
      }

      form_encoded_params = EasyPost::Util.form_encode_params(credit_card_hash)

      uri = URI.parse('https://api.stripe.com/v1/tokens')
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      request = Net::HTTP::Post.new(uri.request_uri, headers)
      query = URI.encode_www_form(form_encoded_params)

      response = http.request(request, query)
      response_json = JSON.parse(response.body)
      response_json['id']
    end

    # Submit Stripe credit card token to EasyPost.
    def create_easypost_credit_card(referral_api_key, stripe_object_id, priority = 'primary')
      wrapped_params = {
        credit_card: {
          stripe_object_id: stripe_object_id,
          priority: priority,
        },
      }
      response = EasyPost.make_request(:post, '/beta/credit_cards', referral_api_key, wrapped_params)
      EasyPost::Util.convert_to_easypost_object(response, referral_api_key)
    end
  end

  # Create a referral customer. This function requires the Partner User's API key.
  # <b>DEPRECATED:</b> Please use <tt>ReferralCustomer</tt> in the main namespace instead.
  def self.create(params = {}, api_key = nil)
    warn '[DEPRECATION] Please use `ReferralCustomer.create` in the main namespace instead.'
    response = EasyPost.make_request(:post, '/beta/referral_customers', api_key, { user: params })
    EasyPost::Util.convert_to_easypost_object(response, api_key)
  end

  # Update a referral customer. This function requires the Partner User's API key.
  # <b>DEPRECATED:</b> Please use <tt>ReferralCustomer</tt> in the main namespace instead.
  def self.update_email(email, user_id, api_key = nil)
    warn '[DEPRECATION] Please use `ReferralCustomer.update_email` in the main namespace instead.'
    wrapped_params = {
      user: {
        email: email,
      },
    }
    EasyPost.make_request(:put, "/beta/referral_customers/#{user_id}", api_key, wrapped_params)

    # return true if API succeeds, else an error is throw if it fails.
    true
  end

  # Retrieve a list of referral customers. This function requires the Partner User's API key.
  # <b>DEPRECATED:</b> Please use <tt>ReferralCustomer</tt> in the main namespace instead.
  def self.all(params = {}, api_key = nil)
    warn '[DEPRECATION] Please use `ReferralCustomer.all` in the main namespace instead.'
    response = EasyPost.make_request(:get, '/beta/referral_customers', api_key, params)
    EasyPost::Util.convert_to_easypost_object(response, api_key)
  end

  # Add credit card to a referral customer. This function requires the ReferralCustomer Customer's API key.
  # <b>DEPRECATED:</b> Please use <tt>ReferralCustomer</tt> in the main namespace instead.
  def self.add_credit_card(referral_api_key, number, expiration_month, expiration_year, cvc, priority = 'primary')
    warn '[DEPRECATION] Please use `ReferralCustomer.add_credit_card` in the main namespace instead.'
    easypost_stripe_api_key = retrieve_easypost_stripe_api_key

    begin
      stripe_credit_card_token = create_stripe_token(
        number,
        expiration_month,
        expiration_year,
        cvc,
        easypost_stripe_api_key,
      )
    rescue StandardError
      raise EasyPost::Error.new('Could not send card details to Stripe, please try again later.')
    end

    response = create_easypost_credit_card(referral_api_key, stripe_credit_card_token, priority)
    EasyPost::Util.convert_to_easypost_object(response, referral_api_key)
  end

  # Add a Stripe payment method to a ReferralCustomer Customer. This function requires the ReferralCustomer Customer's API key.
  # @param [String] stripe_customer_id Unique customer ID provided by Stripe.
  # @param [String] payment_method_reference ID of the card or bank account provided by Stripe.
  # @param [String] payment_method_type Which priority to save this payment method as on EasyPost, either 'primary' or 'secondary'.
  # @param [String] api_key Override the API key used for this request.
  # @return [EasyPost::PaymentMethod] The newly-added payment method.
  # noinspection RubyParameterNamingConvention
  def self.add_payment_method(stripe_customer_id, payment_method_reference, priority = 'primary', api_key = nil)
    wrapped_params = {
      payment_method: {
        stripe_customer_id: stripe_customer_id,
        payment_method_reference: payment_method_reference,
        priority: priority.downcase,
      },
    }
    response = EasyPost.make_request(:post, '/beta/referral_customers/payment_method', api_key, wrapped_params)
    # noinspection RubyMismatchedReturnType
    EasyPost::Util.convert_to_easypost_object(response, api_key)
  end

  # Refund a ReferralCustomer Customer's wallet by a specified amount. Refund will be issued to the user's original payment method.
  # This function requires the ReferralCustomer Customer's API key.
  # @param [Integer] amount The amount to refund, in cents.
  # @param [String] api_key Override the API key used for this request.
  # @return [EasyPost::Beta::PaymentRefund] The newly-created refund.
  def self.refund_by_amount(amount, api_key = nil)
    params = {
      refund_amount: amount,
    }
    response = EasyPost.make_request(:post, '/beta/referral_customers/refunds', api_key, params)
    # noinspection RubyMismatchedReturnType
    EasyPost::Util.convert_to_easypost_object(response, api_key) # TODO: Needs "object" or ID prefix to determine object class.
  end

  # Refund a ReferralCustomer Customer's wallet for a specified payment log entry. Refund will be issued to the user's original payment method.
  # This function requires the ReferralCustomer Customer's API key.
  # @param [String] payment_log_id Payment log ID to refund.
  # @param [String] api_key Override the API key used for this request.
  # @return [EasyPost::Beta::PaymentRefund] The newly-created refund.
  def self.refund_by_payment_log(payment_log_id, api_key = nil)
    params = {
      payment_log_id: payment_log_id,
    }
    response = EasyPost.make_request(:post, '/beta/referral_customers/refunds', api_key, params)
    # noinspection RubyMismatchedReturnType
    EasyPost::Util.convert_to_easypost_object(response, api_key) # TODO: Needs "object" or ID prefix to determine object class.
  end
end
