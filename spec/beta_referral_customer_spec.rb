# frozen_string_literal: true

require 'spec_helper'

describe EasyPost::Services::BetaReferralCustomer do
  let(:client) { EasyPost::Client.new(api_key: ENV['PARTNER_USER_PROD_API_KEY'] || '123') }

  describe '.add_payment_method' do
    it 'adds a Stripe card or bank account to a referral customer account' do
      expect {
        client.beta_referral_customer.add_payment_method(
          'cus_123',
          'ba_123',
        )
      }.to raise_error(EasyPost::Errors::EasyPostError).with_message('Invalid Payment Gateway Reference.')
    end
  end

  describe '.refund_by_amount' do
    it 'refunds a referral user by a specific amount' do
      expect {
        client.beta_referral_customer.refund_by_amount(
          2000,
        )
      }.to raise_error(EasyPost::Errors::EasyPostError).with_message(
        'Refund amount is invalid. Please use a valid amount or escalate to finance.',
      )
    end
  end

  describe '.refund_by_payment_log' do
    it 'refunds a referral user by a specific payment log entry' do
      expect {
        client.beta_referral_customer.refund_by_payment_log(
          'paylog_123',
        )
      }.to raise_error(EasyPost::Errors::EasyPostError).with_message(
        'We could not find a transaction with that id.',
      )
    end
  end

  describe '.create_credit_card_client_secret' do
    it 'returns a client secret for credit cards' do
      response = client.beta_referral_customer.create_credit_card_client_secret()

      expect(response.client_secret).to match('seti_')
    end
  end

  describe '.create_bank_account_client_secret' do
    it 'returns a client secret for bank accounts' do
      response = client.beta_referral_customer.create_bank_account_client_secret()

      expect(response.client_secret).to match('fcsess_client_secret_')
    end
  end
end
