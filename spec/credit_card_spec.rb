# frozen_string_literal: true

require 'spec_helper'

describe EasyPost::CreditCard, :authenticate_prod do
  describe '.fund' do
    xit 'fund a credit card' do
      # Skipping due to the lack of an available real credit card in tests
      credit_card = described_class.fund('2000', 'primary')

      expect(credit_card).not_to be_nil
    end
  end

  describe '.delete' do
    xit 'delete a credit card by ID' do
      # Skipping due to the lack of an available real credit card in tests
      deleted_credit_card = described_class.delete('card_123')

      expect(deleted_credit_card).not_to be_nil
    end
  end
end
