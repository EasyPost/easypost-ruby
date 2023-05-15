# frozen_string_literal: true

# ReferralCustomer objects are User objects created from a Partner user.
class EasyPost::Services::ReferralCustomer < EasyPost::Services::Service
  MODEL_CLASS = EasyPost::Models::User

  # Create a referral customer. This function requires the Partner User's API key.
  def create(params = {})
    @client.make_request(:post, 'referral_customers', MODEL_CLASS, { user: params })
  end

  # Update a referral customer. This function requires the Partner User's API key.
  def update_email(user_id, email)
    wrapped_params = {
      user: {
        email: email,
      },
    }
    @client.make_request(:put, "referral_customers/#{user_id}", MODEL_CLASS, wrapped_params)

    # return true if API succeeds, else an error is throw if it fails.
    true
  end

  # Retrieve a list of referral customers. This function requires the Partner User's API key.
  def all(params = {})
    @client.make_request(:get, 'referral_customers', MODEL_CLASS, params)
  end

  # Get the next page of referral customers.
  def get_next_page(collection, page_size = nil)
    get_next_page_exec(collection, collection.referral_customers, 'referral_customers', MODEL_CLASS, page_size)
  end

  # Add credit card to a referral customer. This function requires the ReferralCustomer Customer's API key.
  def add_credit_card(referral_api_key, number, expiration_month, expiration_year, cvc, priority = 'primary')
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

    create_easypost_credit_card(referral_api_key, stripe_credit_card_token, priority)
  end

  private

  # Retrieve EasyPost's Stripe public API key.
  def retrieve_easypost_stripe_api_key
    response = @client.make_request(:get, 'partners/stripe_public_key', EasyPost::Models::EasyPostObject, nil, 'beta')
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
    referral_client = EasyPost::Client.new(api_key: referral_api_key)
    referral_client.make_request(:get, 'credit_cards', EasyPost::Models::EasyPostObject, wrapped_params, 'beta')
  end
end
