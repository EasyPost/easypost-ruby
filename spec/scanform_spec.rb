# frozen_string_literal: true

require 'spec_helper'

describe EasyPost::ScanForm do
  describe '.create' do
    it 'creates a scanform' do
      shipment = EasyPost::Shipment.create(Fixture.one_call_buy_shipment)

      scanform = described_class.create(
        shipments: [shipment],
      )

      expect(scanform).to be_an_instance_of(described_class)
      expect(scanform.id).to match('sf_')
    end
  end

  describe '.retrieve' do
    it 'retrieves a scanform' do
      shipment = EasyPost::Shipment.create(Fixture.one_call_buy_shipment)

      scanform = described_class.create(
        shipments: [shipment],
      )

      retrieved_scanform = described_class.retrieve(scanform.id)

      expect(retrieved_scanform).to be_an_instance_of(described_class)
      expect(retrieved_scanform.to_s).to eq(scanform.to_s)
    end
  end

  describe '.all' do
    it 'retrieves all scanforms' do
      scanforms = described_class.all(
        page_size: Fixture.page_size,
      )

      scanforms_array = scanforms.scan_forms

      expect(scanforms_array.count).to be <= Fixture.page_size
      expect(scanforms.has_more).not_to be_nil
      expect(scanforms_array).to all(be_an_instance_of(described_class))
    end
  end
end
