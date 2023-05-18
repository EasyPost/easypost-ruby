# frozen_string_literal: true

require 'spec_helper'

describe EasyPost::Services::Billing do
  let(:client) { EasyPost::Client.new(api_key: ENV['EASYPOST_PROD_API_KEY']) }

  describe '.fund_wallet' do
    it 'fund wallet by using a payment method' do
      allow(described_class).to receive(:get_payment_method_info).and_return(['/credit_cards', 'cc_123'])
      allow(client).to receive(:make_request).with(
        :post, '/credit_cards/cc_123/charges', EasyPost::Models::EasyPostObject, { amount: '2000' },
      )

      credit_card = client.billing.fund_wallet('2000', 'primary')

      expect(credit_card).to eq(true)
    end
  end

  describe '.delete_payment_method' do
    it 'delete a payment method' do
      allow(described_class).to receive(:get_payment_method_info).and_return(['/credit_cards', 'cc_123'])
      allow(client).to receive(:make_request).with(
        :delete, '/credit_cards/cc_123',
      )

      deleted_credit_card = client.billing.delete_payment_method('primary')

      expect(deleted_credit_card).to eq(true)
    end
  end
end
