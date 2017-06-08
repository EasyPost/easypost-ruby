require 'spec_helper'

describe EasyPost::Order do
  describe '#lowest_rate' do
    it 'gets lowest rate' do
      order = EasyPost::Order.create(
        to_address: ADDRESS[:california],
        from_address: ADDRESS[:missouri],
        shipments: [{
          parcel: {length: 8, width: 6, height: 4, weight: 12}
        }]
      )

      rate = order.lowest_rate('!UPS')
      expect(rate).not_to be_nil
      expect(rate.service).not_to eq('NextDayAir')
      expect(rate.service).not_to eq('Express')
    end
  end
  describe '#get_rates' do
    it 'refreshes rates' do
      order = EasyPost::Order.create(
        to_address: ADDRESS[:california],
        from_address: ADDRESS[:missouri],
        shipments: [{
          parcel: {length: 8, width: 6, height: 4, weight: 12}
        }]
      )

      expect(order).to be_an_instance_of(EasyPost::Order)
      expect(order.shipments.first).to be_an_instance_of(EasyPost::Shipment)

      rate_id = order.shipments.first.rates.first.id
      expect(rate_id).not_to be_nil

      order.get_rates

      new_rate_id = order.shipments.first.rates.first.id
      expect(new_rate_id).not_to be_nil
      expect(new_rate_id).not_to eq(rate_id)
    end
  end

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
        carrier_accounts: [{id: "ca_12345678"}],
        shipments: [{
          parcel: {length: 8, width: 6, height: 4, weight: 12}
        },{
          parcel: {length: 8, width: 6, height: 4, weight: 12}
        }]
      )

      expect(order).to be_an_instance_of(EasyPost::Order)
      expect(order.shipments.first).to be_an_instance_of(EasyPost::Shipment)
    end
  end
end
