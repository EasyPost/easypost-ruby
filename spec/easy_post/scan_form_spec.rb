# frozen_string_literal: true

require 'spec_helper'

describe EasyPost::ScanForm do
  let(:shipment) do
    shipment = EasyPost::Shipment.create(
      to_address: ADDRESS[:canada],
      from_address: ADDRESS[:california],
      parcel: PARCEL[:dimensions],
      customs_info: CUSTOMS_INFO[:shirt],
    )

    shipment.buy(
      rate: shipment.lowest_rate('usps'),
    )
  end

  describe '#create' do
    it 'purchases postage for an international shipment' do
      scan_form = described_class.create(shipments: [shipment])

      expect(scan_form.id).not_to be_nil
      expect(scan_form.tracking_codes.first).to eq(shipment.tracking_code)
    end
  end

  describe '#retrieve' do
    let(:scan_form) { described_class.create(shipments: [shipment]) }

    it 'retrieves the same scan_form' do
      scan_form2 = described_class.retrieve(scan_form.id)

      expect(scan_form2.id).to eq(scan_form.id)
    end
  end

  describe '#all' do
    let!(:scan_form) { described_class.create(shipments: [shipment]) }

    it 'indexes the scan_forms' do
      params = { page_size: 2 }
      scan_forms = described_class.all(params)

      expect(scan_forms['scan_forms'].first.id).to eq(scan_form.id)
    end
  end
end
