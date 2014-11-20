require 'spec_helper'

describe EasyPost::Order do
  describe '#create' do
    it 'creates an order out of a single shipment' do
      order = EasyPost::Order.create(
        to_address: ADDRESS[:california],
        from_address: ADDRESS[:missouri],
        shipments: [{
          parcel: {length: 8, width: 6, height: 4, weight: 12}
        }]
      )

      expect(order).to be_an_instance_of(EasyPost::Order)
      expect(order.shipments.first).to be_an_instance_of(EasyPost::Shipment)
    end

    it 'creates an order out of two shipments' do

      order = EasyPost::Order.create(
        to_address: ADDRESS[:california],
        from_address: ADDRESS[:missouri],
        shipments: [{
          parcel: {length: 8, width: 6, height: 4, weight: 12}
        },{
          parcel: {length: 8, width: 6, height: 4, weight: 12}
        }]
      )

      expect(order).to be_an_instance_of(EasyPost::Order)
      expect(order.shipments.first).to be_an_instance_of(EasyPost::Shipment)
    end

    it 'creates and buys an international order out of two shipments' do

      order = EasyPost::Order.create(
        to_address: ADDRESS[:california],
        from_address: ADDRESS[:missouri],
        customs_info: EasyPost::CustomsInfo.create(CUSTOMS_INFO[:shirt]),
        shipments: [{
          parcel: {length: 8, width: 6, height: 4, weight: 12}
        },{
          parcel: {length: 8, width: 6, height: 4, weight: 24}
        }]
      )
      order.buy(carrier: "usps", service: "ParcelSelect")

      expect(order).to be_an_instance_of(EasyPost::Order)
      expect(order.shipments.first).to be_an_instance_of(EasyPost::Shipment)
    end
  end
end
