# frozen_string_literal: true

require 'spec_helper'

describe EasyPost::PaymentMethod do
  describe '.all' do
    it 'retrieves all payment methods' do
      allow(EasyPost::Billing).to receive(:retrieve_payment_methods)

      described_class.all
    end
  end
end
