# frozen_string_literal: true

require 'spec_helper'

REFERRAL_CUSTOMER_PROD_API_KEY = ENV['REFERRAL_CUSTOMER_PROD_API_KEY'] || '123'

describe EasyPost::Services::BetaReferralCustomer do
  let(:client) { EasyPost::Client.new(api_key: ENV['PARTNER_USER_PROD_API_KEY'] || '123') }

  describe '.add_payment_method' do
    it 'adds a Stripe card or bank account to a referral customer account' do
      # This test requires a referral customer's production API key via REFERRAL_CUSTOMER_PROD_API_KEY.
      expect {
        client.beta_referral_customer.add_payment_method(
          'cus_123',
          'ba_123',
        )
      }.to raise_error(EasyPost::Exceptions::EasyPostError).with_message('Invalid Payment Gateway Reference.')
    end
  end

  describe '.refund_by_amount' do
    it 'refunds a referral user by a specific amount' do
      # This test requires a referral customer's production API key via REFERRAL_CUSTOMER_PROD_API_KEY.
      expect {
        client.beta_referral_customer.refund_by_amount(
          2000,
        )
      }.to raise_error(EasyPost::Exceptions::EasyPostError).with_message(
        'Refund amount is invalid. Please use a valid amount or escalate to finance.',
      )
    end
  end

  describe '.refund_by_payment_log' do
    it 'refunds a referral user by a specific payment log entry' do
      # This test requires a referral customer's production API key via REFERRAL_CUSTOMER_PROD_API_KEY.
      expect {
        client.beta_referral_customer.refund_by_payment_log(
          'paylog_123',
        )
      }.to raise_error(EasyPost::Exceptions::EasyPostError).with_message(
        'We could not find a transaction with that id.',
      )
    end
  end
end
