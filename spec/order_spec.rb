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
        # to_address: ADDRESS[:canada],
        to_address: ADDRESS[:california],
        from_address: ADDRESS[:missouri],
        customs_info: CUSTOMS_INFO[:shirt],
        shipments: [{
          parcel: {length: 8, width: 6, height: 4, weight: 12}
        },{
          parcel: {length: 8, width: 6, height: 4, weight: 24}
        }]
      )
      order.buy(carrier: "fedex", service: "FEDEX_GROUND")

      expect(order).to be_an_instance_of(EasyPost::Order)
      expect(order.shipments.first).to be_an_instance_of(EasyPost::Shipment)
    end


    # it 'creates an order object out of a single item' do
    #   order = EasyPost::Order.create(
    #     :to_address   => ADDRESS[:california],
    #     :from_address => ADDRESS[:missouri],
    #     :containers   => "*", # only uses your containers
    #     :items        => [ITEM[:shirt]]
    #   )
    #   expect(order).to be_an_instance_of(EasyPost::Order)
    #   expect(order.shiments.first).to be_an_instance_of(EasyPost::Shipment)
    #   expect(order.shiments.first.from_address).to be_an_instance_of(EasyPost::Address)
    #   expect(order.shiments.length).to eq(1)
    # end

    # it 'creates an order object out of multiple items' do
    #   order = EasyPost::Order.create(
    #     :to_address   => ADDRESS[:california],
    #     :from_address => ADDRESS[:missouri],
    #     :containers   => ["USPS.FLAT_RATE.*", "USPS.REGIONAL_RATE.*"],
    #     :items        => [ITEM[:shirt], ITEM[:pants]]
    #   )
    #   expect(order).to be_an_instance_of(EasyPost::Order)
    #   expect(order.shiments.first).to be_an_instance_of(EasyPost::Shipment)
    #   expect(order.shiments.first.from_address).to be_an_instance_of(EasyPost::Address)
    # end

    # it 'creates an order object with options' do
    #   order = EasyPost::Order.create(
    #     :to_address   => ADDRESS[:california],
    #     :from_address => ADDRESS[:missouri],
    #     :containers   => [{id: "container_USPSFR01"}, "USPS.REGIONAL_RATE.*"],
    #     :items        => [ITEM[:shirt], ITEM[:pants]],
    #     :options      => {alcohol: true}
    #   )
    #   expect(order).to be_an_instance_of(EasyPost::Order)
    #   expect(order.shiments.first).to be_an_instance_of(EasyPost::Shipment)
    #   expect(order.shiments.first.options[:alcohol]).to be_true
    # end

    # it 'creates an order object with custom item and passed without array' do
    #   item = EasyPost::Item.create(
    #     name: "Test Item",
    #     sku: "1234567890",
    #     length: 6.0,
    #     width: 8.0,
    #     height: 10,
    #     weight: 13,
    #     value: 13.00
    #   ))
    #   item.value = 9.99

    #   order = EasyPost::Order.create(
    #     :to_address   => ADDRESS[:california],
    #     :from_address => ADDRESS[:missouri],
    #     :containers   => EasyPost::Container::ALL,
    #     :items        => item
    #   )
    #   expect(order.shiments.first.item).to be_an_instance_of(EasyPost::Item)
    #   expect(order.shiments.first.item.value).to eq(9.99)
    #   expect(order.shiments.first.item.sku).to eq("1234567890")

    # end
  end

end
