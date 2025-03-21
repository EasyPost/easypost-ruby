# frozen_string_literal: true

class EasyPost::Services::ReferralCustomer < EasyPost::Services::Service
  MODEL_CLASS = EasyPost::Models::User # :nodoc:

  # Create a referral customer. This function requires the Partner User's API key.
  def create(params = {})
    response = @client.make_request(:post, 'referral_customers', { user: params })

    EasyPost::InternalUtilities::Json.convert_json_to_object(response, MODEL_CLASS)
  end

  # Update a referral customer. This function requires the Partner User's API key.
  def update_email(user_id, email)
    wrapped_params = {
      user: {
        email: email,
      },
    }
    @client.make_request(:put, "referral_customers/#{user_id}", wrapped_params)

    # return true if API succeeds, else an error is throw if it fails.
    true
  end

  # Retrieve a list of referral customers. This function requires the Partner User's API key.
  def all(params = {})
    filters = { key: 'referral_customers' }

    get_all_helper('referral_customers', MODEL_CLASS, params, filters)
  end

  # Get the next page of referral customers.
  def get_next_page(collection, page_size = nil)
    raise EasyPost::Errors::EndOfPaginationError.new unless more_pages?(collection)

    params = { before_id: collection.referral_customers.last.id }
    params[:page_size] = page_size unless page_size.nil?

    all(params)
  end

  # Add a credit card to EasyPost for a ReferralCustomer without needing a Stripe account. This function requires the ReferralCustomer User's API key.
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
      raise EasyPost::Errors::ExternalApiError.new(EasyPost::Constants::STRIPE_CARD_CREATE_FAILED)
    end

    create_easypost_credit_card(referral_api_key, stripe_credit_card_token, priority)
  end

  # Add a credit card to EasyPost for a ReferralCustomer with a payment method ID from Stripe. This function requires the ReferralCustomer User's API key.
  def add_credit_card_from_stripe(referral_api_key, payment_method_id, priority = 'primary')
    params = {
      credit_card: {
        payment_method_id: payment_method_id,
        priority: priority,
      },
    }
    referral_client = EasyPost::Client.new(api_key: referral_api_key)
    response = referral_client.make_request(
      :post,
      'credit_cards',
      params,
    )

    EasyPost::InternalUtilities::Json.convert_json_to_object(response)
  end

  # Add a bank account to EasyPost for a ReferralCustomer. This function requires the ReferralCustomer User's API key.
  def add_bank_account_from_stripe(referral_api_key, financial_connections_id, mandate_data, priority = 'primary')
    params = {
      financial_connections_id: financial_connections_id,
      mandate_data: mandate_data,
      priority: priority,
    }
    referral_client = EasyPost::Client.new(api_key: referral_api_key)
    response = referral_client.make_request(
      :post,
      'bank_accounts',
      params,
    )

    EasyPost::InternalUtilities::Json.convert_json_to_object(response)
  end

  private

  # Retrieve EasyPost's Stripe public API key.
  def retrieve_easypost_stripe_api_key
    response = @client.make_request(:get, 'partners/stripe_public_key', nil, 'beta')
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

    form_encoded_params = EasyPost::InternalUtilities.form_encode_params(credit_card_hash)

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
    response = referral_client.make_request(
      :post,
      'credit_cards',
      wrapped_params,
      'beta',
    )

    EasyPost::InternalUtilities::Json.convert_json_to_object(response)
  end
end
