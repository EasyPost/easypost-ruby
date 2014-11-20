require 'spec_helper'

describe EasyPost::Batch do
  describe '#create' do
    it 'creates a batch object' do
      batch = EasyPost::Batch.create({
        shipment: [{
          from_address: ADDRESS[:california],
          to_address: EasyPost::Address.create(ADDRESS[:missouri]),
          parcel: EasyPost::Parcel.create(PARCEL[:dimensions])
        }, {
          from_address: ADDRESS[:california],
          to_address: EasyPost::Address.create(ADDRESS[:canada]),
          parcel: EasyPost::Parcel.create(PARCEL[:dimensions]),
        }],
        reference: "batch123456789"
      })
      expect(batch).to be_an_instance_of(EasyPost::Batch)
      expect(batch.num_shipments).to eq(2)
      expect(batch.reference).to eq("batch123456789")
      expect(batch.state).to eq("creating")
    end
  end

  describe '#create_and_buy' do
    it 'creates a batch object and delayed jobs for purchasing the postage_labels' do
      batch = EasyPost::Batch.create({
        shipment: [{
          from_address: ADDRESS[:california],
          to_address: EasyPost::Address.create(ADDRESS[:missouri]),
          parcel: EasyPost::Parcel.create(PARCEL[:dimensions]),
          carrier: "usps",
          service: "priority"
        }, {
          from_address: ADDRESS[:california],
          to_address: EasyPost::Address.create(ADDRESS[:canada]),
          parcel: EasyPost::Parcel.create(PARCEL[:dimensions]),
          carrier: "usps",
          service: "prioritymailinternational"
        }],
        reference: "batch123456789"
      })
      expect(batch).to be_an_instance_of(EasyPost::Batch)
      expect(batch.state).to eq("creating")
      expect(batch.num_shipments).to eq(2)
    end
  end
end
