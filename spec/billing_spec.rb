# frozen_string_literal: true

require 'spec_helper'

describe EasyPost::Billing, :authenticate_prod do
  describe '.fund_wallet' do
    xit 'fund wallet by using a payment method' do
      # Skipping due to the lack of an available real payment method in tests
      credit_card = described_class.fund_wallet('2000', 'primary')

      expect(credit_card).to eq(true)
    end
  end

  describe '.delete_payment_method' do
    xit 'delete a payment method' do
      # Skipping due to the lack of an available real payment method in tests
      deleted_credit_card = described_class.delete_payment_method('primary')

      expect(deleted_credit_card).to eq(true)
    end
  end

  describe '.retrieve_payment_methods' do
    xit 'retrieves all payment methods' do
      # Skipping due to the lack of an available real payment method in tests
      payment_methods = described_class.retrieve_payment_methods

      expect(payment_methods.primary_payment_method).not_to be_nil
      expect(payment_methods.secondary_payment_method).not_to be_nil
      # comment above assertion(s) if you don't have payment method(s)
    end
  end
end
