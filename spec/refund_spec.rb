# frozen_string_literal: true

require 'spec_helper'

describe EasyPost::Refund do
  describe '.create' do
    it 'creates a refund' do
      shipment = EasyPost::Shipment.create(Fixture.one_call_buy_shipment)
      retrieved_shipment = EasyPost::Shipment.retrieve(shipment.id) # We need to retrieve the shipment so that the tracking_code has time to populate

      refund = described_class.create(
        carrier: Fixture.usps,
        tracking_codes: retrieved_shipment.tracking_code,
      )

      expect(refund[0].id).to match('rfnd')
      expect(refund[0].status).to eq('submitted')
    end
  end

  describe '.all' do
    it 'retrieves all refunds' do
      refunds = described_class.all(
        page_size: Fixture.page_size,
      )

      refunds_array = refunds.refunds

      expect(refunds_array.count).to be <= Fixture.page_size
      expect(refunds.has_more).not_to be_nil
      expect(refunds_array).to all(be_an_instance_of(described_class))
    end
  end

  describe '.retrieve' do
    it 'retrieves a refund' do
      shipment = EasyPost::Shipment.create(Fixture.one_call_buy_shipment)
      retrieved_shipment = EasyPost::Shipment.retrieve(shipment.id) # We need to retrieve the shipment so that the tracking_code has time to populate

      refund = described_class.create(
        carrier: Fixture.usps,
        tracking_codes: retrieved_shipment.tracking_code,
      )

      retrieved_refund = described_class.retrieve(refund[0].id)

      expect(retrieved_refund).to be_an_instance_of(described_class)
      expect(retrieved_refund.id).to eq(refund[0].id)
    end
  end
end
