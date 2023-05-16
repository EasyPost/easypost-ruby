# frozen_string_literal: true

# ReferralCustomer objects are User objects created from a Partner user.
class EasyPost::Referral < EasyPost::Resource
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
  def self.create(params = {}, api_key = nil)
    response = EasyPost.make_request(:post, '/v2/referral_customers', api_key, { user: params })
    EasyPost::Util.convert_to_easypost_object(response, api_key)
  end

  # Update a referral customer. This function requires the Partner User's API key.
  def self.update_email(email, user_id, api_key = nil)
    wrapped_params = {
      user: {
        email: email,
      },
    }
    EasyPost.make_request(:put, "/v2/referral_customers/#{user_id}", api_key, wrapped_params)

    # return true if API succeeds, else an error is throw if it fails.
    true
  end

  # Retrieve a list of referral customers. This function requires the Partner User's API key.
  def self.all(params = {}, api_key = nil)
    response = EasyPost.make_request(:get, '/v2/referral_customers', api_key, params)
    EasyPost::Util.convert_to_easypost_object(response, api_key)
  end

  # Get the next page of referral customers.
  def self.get_next_page(collection, page_size = nil)
    get_next_page_exec(method(:all), collection, collection.referral_customers, page_size)
  end

  # Build the next page parameters.
  def self.build_next_page_params(_collection, current_page_items, page_size = nil)
    params = {}
    params[:before_id] = current_page_items.last.id
    unless page_size.nil?
      params[:page_size] = page_size
    end
    params
  end

  # Add credit card to a referral customer. This function requires the ReferralCustomer Customer's API key.
  def self.add_credit_card(referral_api_key, number, expiration_month, expiration_year, cvc, priority = 'primary')
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
end
