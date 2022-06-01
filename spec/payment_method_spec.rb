# frozen_string_literal: true

require 'spec_helper'

describe EasyPost::PaymentMethod, :authenticate_prod do
  describe '.all' do
    it 'retrieves all payment methods' do
      payment_methods = described_class.all

      expect(payment_methods.primary_payment_method).not_to be_nil
      expect(payment_methods.secondary_payment_method).not_to be_nil
    end
  end
end
