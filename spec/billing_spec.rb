# frozen_string_literal: true

require 'spec_helper'

describe EasyPost::Billing, :authenticate_prod do
  describe '.fund_wallet' do
    it 'fund wallet by using a payment method' do
      allow(described_class).to receive(:get_payment_method_info).and_return(['/credit_cards', 'cc_123'])
      allow(EasyPost).to receive(:make_request).with(
        :post, '/credit_cards/cc_123/charges', nil, { amount: '2000' },
      )

      credit_card = described_class.fund_wallet('2000', 'primary')

      expect(credit_card).to eq(true)
    end
  end

  describe '.delete_payment_method' do
    it 'delete a payment method' do
      allow(described_class).to receive(:get_payment_method_info).and_return(['/credit_cards', 'cc_123'])
      allow(EasyPost).to receive(:make_request).with(
        :delete, '/credit_cards/cc_123', nil,
      )

      deleted_credit_card = described_class.delete_payment_method('primary')

      expect(deleted_credit_card).to eq(true)
    end
  end

  describe '.retrieve_payment_methods' do
    it 'retrieves all payment methods when none have been setup' do
      allow(EasyPost).to receive(:make_request).with(
        :get, '/v2/payment_methods', nil,
      ).and_return({ mock: 'response' })

      expect {
        described_class.retrieve_payment_methods
      }.to raise_error(EasyPost::Error)
        .with_message('Billing has not been setup for this user. Please add a payment method.')
    end

    it 'retrieves all payment methods' do
      allow(EasyPost).to receive(:make_request).with(
        :get, '/v2/payment_methods', nil,
      ).and_return(
        {
          'id' => '123',
        },
      )

      response = described_class.retrieve_payment_methods

      expect(response).to be_an_instance_of(EasyPost::EasyPostObject)
    end

    it 'deserializes the payment methods by ID prefix' do
      allow(EasyPost).to receive(:make_request).with(
        :get, '/v2/payment_methods', nil,
      ).and_return(
        {
          'id' => '123',
          'primary_payment_method' => { 'id' => 'bank_123' },
          'secondary_payment_method' => { 'id' => 'card_123' },
        },
      )

      response = described_class.retrieve_payment_methods

      expect(response).to be_an_instance_of(EasyPost::EasyPostObject)
      expect(response[:primary_payment_method]).to be_an_instance_of(EasyPost::PaymentMethod)
      expect(response[:secondary_payment_method]).to be_an_instance_of(EasyPost::PaymentMethod)
    end

    # TODO: Reactivate when deserialization by "object" is fixed
    skip it 'deserializes the payment methods by object type' do
      allow(EasyPost).to receive(:make_request).with(
        :get, '/v2/payment_methods', nil,
      ).and_return(
        {
          'id' => '123',
          'primary_payment_method' => { 'object' => 'BankAccount' },
          'secondary_payment_method' => { 'object' => 'CreditCard' },
        },
      )

      response = described_class.retrieve_payment_methods

      expect(response).to be_an_instance_of(EasyPost::EasyPostObject)
      expect(response[:primary_payment_method]).to be_an_instance_of(EasyPost::PaymentMethod)
      expect(response[:secondary_payment_method]).to be_an_instance_of(EasyPost::PaymentMethod)
    end

    it 'does not deserialize the payment methods if prefix and object type missing' do
      allow(EasyPost).to receive(:make_request).with(
        :get, '/v2/payment_methods', nil,
      ).and_return(
        {
          'id' => '123',
          'primary_payment_method' => { 'random_key' => 'random_value' },
          'secondary_payment_method' => { 'random_key' => 'random_value' },
        },
      )

      response = described_class.retrieve_payment_methods

      expect(response).to be_an_instance_of(EasyPost::EasyPostObject)
      expect(response[:primary_payment_method]).to be_an_instance_of(EasyPost::EasyPostObject)
      expect(response[:secondary_payment_method]).to be_an_instance_of(EasyPost::EasyPostObject)
    end
  end

  describe '.get_payment_method_info' do
    it 'tests we raise an error when we cannot retrieve a payment method' do
      allow(described_class).to receive(:retrieve_payment_methods)
        .and_return({ 'primary_payment_method' => { 'id' => 'bad_id' } })

      expect {
        described_class.send(:get_payment_method_info, 'tertiary')
      }.to raise_error(EasyPost::Error).with_message('The chosen payment method is not valid. Please try again.')
    end

    it 'tests that we return the correct info for valid credit cards' do
      allow(described_class).to receive(:retrieve_payment_methods)
        .and_return({ 'primary_payment_method' => { 'id' => 'card_123' } })

      payment_info = described_class.send(:get_payment_method_info, 'primary')

      endpoint = payment_info[0]
      payment_id = payment_info[1]

      expect(endpoint).to eq('/v2/credit_cards')
      expect(payment_id).to eq('card_123')
    end

    it 'tests that we return the correct info for valid bank accounts' do
      allow(described_class).to receive(:retrieve_payment_methods)
        .and_return({ 'primary_payment_method' => { 'id' => 'bank_123' } })

      payment_info = described_class.send(:get_payment_method_info, 'primary')

      endpoint = payment_info[0]
      payment_id = payment_info[1]

      expect(endpoint).to eq('/v2/bank_accounts')
      expect(payment_id).to eq('bank_123')
    end

    it 'tests that we raise an error when the ID returned is invalid' do
      allow(described_class).to receive(:retrieve_payment_methods)
        .and_return({ 'primary_payment_method' => { 'id' => 'invalid' } })

      expect {
        described_class.send(:get_payment_method_info, 'primary')
      }.to raise_error(EasyPost::Error).with_message('The chosen payment method is not valid. Please try again.')
    end
  end
end
