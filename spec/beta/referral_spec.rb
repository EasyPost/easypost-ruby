# frozen_string_literal: true

require 'spec_helper'

REFERRAL_CUSTOMER_PROD_API_KEY = ENV['REFERRAL_CUSTOMER_PROD_API_KEY'] || '123'

describe EasyPost::Beta::ReferralCustomer, :authenticate_partner do
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
      skip 'Skip until the API key has the feature turned on'
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

    it 'raises an error when we cannot send details to Stripe' do
      skip 'Skip until the API key has the feature turned on'
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

  describe '.add_payment_method', :authenticate_referral do
    it 'adds a Stripe card or bank account to a referral customer account' do
      # This test requires a referral customer's production API key via REFERRAL_CUSTOMER_PROD_API_KEY.
      expect {
        described_class.add_payment_method(
          'cus_123',
          'ba_123',
        )
      }.to raise_error(EasyPost::Error).with_message('Invalid Payment Gateway Reference.')
    end
  end

  describe '.refund_by_amount', :authenticate_referral do
    it 'refunds a referral user by a specific amount' do
      # This test requires a referral customer's production API key via REFERRAL_CUSTOMER_PROD_API_KEY.
      expect {
        described_class.refund_by_amount(
          2000,
        )
      }.to raise_error(EasyPost::Error).with_message(
        'Refund amount is invalid. Please use a valid amount or escalate to finance.',
      )
    end
  end

  describe '.refund_by_payment_log', :authenticate_referral do
    it 'refunds a referral user by a specific payment log entry' do
      # This test requires a referral customer's production API key via REFERRAL_CUSTOMER_PROD_API_KEY.
      expect {
        described_class.refund_by_payment_log(
          'paylog_123',
        )
      }.to raise_error(EasyPost::Error).with_message(
        'We could not find a transaction with that id.',
      )
    end
  end
end
