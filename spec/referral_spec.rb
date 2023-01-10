# frozen_string_literal: true

require 'spec_helper'

REFERRAL_CUSTOMER_PROD_API_KEY = ENV['REFERRAL_CUSTOMER_PROD_API_KEY'] || '123'

describe EasyPost::Referral, :authenticate_partner do
  describe '.create' do
    it 'creates a referral customer' do
      # This test requires a partner user's production API key via PARTNER_USER_PROD_API_KEY.
      created_referral_customer = described_class.create(
        name: 'test user',
        email: 'email@example.com',
        phone: '8888888888',
      )

      expect(created_referral_customer).to be_an_instance_of(EasyPost::User)
      expect(created_referral_customer.id).to match('user_')
      expect(created_referral_customer.name).to eq('test user')
    end
  end

  describe '.update_email' do
    it 'updates a referral customer' do
      # This test requires a partner user's production API key via PARTNER_USER_PROD_API_KEY.
      referral_customers = described_class.all(
        page_size: Fixture.page_size,
      )

      updated_user = described_class.update_email(
        'email2@example.com',
        referral_customers.referral_customers[0].id,
      )

      expect(updated_user).to eq(true)
    end
  end

  describe '.all' do
    # This test requires a partner user's production API key via PARTNER_USER_PROD_API_KEY.
    it 'retrieve all referral customers' do
      referral_customers = described_class.all(
        page_size: Fixture.page_size,
      )

      referral_customers_array = referral_customers.referral_customers

      expect(referral_customers_array.count).to be <= Fixture.page_size
      expect(referral_customers.has_more).not_to be_nil
      expect(referral_customers_array).to all(be_an_instance_of(EasyPost::User))
    end
  end

  describe '.add_credit_card' do
    it 'adds a credit card to a referral customer account' do
      # We override the VCR config here since it cannot match the URL due to data scrubbing
      VCR.use_cassette(
        'referral/EasyPost_Referral_add_credit_card_adds_a_credit_card_to_a_referral_customer_account',
        match_requests_on: [:method, :uri],
      ) do
        # This test requires a partner user's production API key via PARTNER_USER_PROD_API_KEY
        # as well as one of that user's referral's production API keys via REFERRAL_CUSTOMER_PROD_API_KEY.
        credit_card = described_class.add_credit_card(
          REFERRAL_CUSTOMER_PROD_API_KEY,
          Fixture.credit_card_details['number'],
          Fixture.credit_card_details['expiration_month'],
          Fixture.credit_card_details['expiration_year'],
          Fixture.credit_card_details['cvc'],
        )

        expect(credit_card.id).to match('card_')
        expect(credit_card.last4).to match('6170')
      end
    end

    it 'raises an error when we cannot send details to Stripe' do
      allow(described_class).to receive(:create_stripe_token).and_raise(StandardError)
      allow(described_class).to receive(:retrieve_easypost_stripe_api_key)

      expect {
        described_class.add_credit_card(
          REFERRAL_CUSTOMER_PROD_API_KEY,
          Fixture.credit_card_details['number'],
          Fixture.credit_card_details['expiration_month'],
          Fixture.credit_card_details['expiration_year'],
          Fixture.credit_card_details['cvc'],
        )
      }.to raise_error(StandardError).with_message('Could not send card details to Stripe, please try again later.')
    end
  end
end
