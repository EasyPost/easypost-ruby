require 'spec_helper'

describe 'fedex domestic' do
  before(:all) do
    @rates = {}
  end

  it 'buys a commercial ground label' do
    shipment = EasyPost::Shipment.create(
      :to_address   => ADDRESS[:california],
      :from_address => ADDRESS[:missouri],
      :parcel       => PARCEL[:dimensions]
    )
    shipment.buy(:rate => shipment.lowest_rate("fedex", "FEDEX_GROUND"))
    label = open(shipment.postage_label.label_url)

    expect(shipment).to be_an_instance_of(EasyPost::Shipment)
    expect(shipment.selected_rate).to be_an_instance_of(EasyPost::Rate)
    expect(shipment.selected_rate.service).to eq("FEDEX_GROUND")
    expect(shipment.postage_label.label_url).to end_with(".png")
    expect(shipment.tracking_code).to start_with("8000")
    expect(label.size).to be > 5000

    @rates[:commercial] = shipment.selected_rate
  end

   it 'buys a residential ground label' do
    shipment = EasyPost::Shipment.create(
      :to_address   => ADDRESS[:california],
      :from_address => ADDRESS[:missouri],
      :parcel       => PARCEL[:dimensions],
      :options      => {:residential_to_address => true}
    )
    shipment.buy(:rate => shipment.lowest_rate("fedex", "GROUND_HOME_DELIVERY"))
    label = open(shipment.postage_label.label_url)

    expect(shipment.selected_rate.service).to eq("GROUND_HOME_DELIVERY")
    expect(shipment.tracking_code).to start_with("8000")
    expect(label.size).to be > 5000

    @rates[:residential] = shipment.selected_rate
  end

  it 'buys a ground evening delivery label' do
    shipment = EasyPost::Shipment.create(
      :to_address   => ADDRESS[:california],
      :from_address => ADDRESS[:missouri],
      :parcel       => PARCEL[:dimensions],
      :options      => {:residential_to_address => true,
                        :delivery_time_preference => "evening"}
    )
    shipment.buy(:rate => shipment.lowest_rate("fedex", "GROUND_HOME_DELIVERY"))

    expect(shipment.postage_label.label_url).to end_with(".png")

    @rates[:residential_evening] = shipment.selected_rate
  end

  it 'raises error without recipient phone number' do
    shipment = EasyPost::Shipment.create(
      :to_address   => ADDRESS[:california_no_phone],
      :from_address => ADDRESS[:missouri],
      :parcel       => PARCEL[:dimensions]
    )

    expect { shipment.buy(rate: shipment.lowest_rate("fedex")) }.to raise_error(EasyPost::Error, /Unable to buy FedEx shipment without recipient phone number./)
  end

  it 'buys a label for an alcoholic shipment with epl2 label' do
    shipment = EasyPost::Shipment.create(
      :to_address   => ADDRESS[:california],
      :from_address => ADDRESS[:missouri],
      :parcel       => PARCEL[:dimensions],
      :options      => {
        :alcohol      => 1,
        :label_format => "epl2"
      }
    )
    shipment.buy(:rate => shipment.lowest_rate("fedex", "PRIORITY_OVERNIGHT"))

    expect(shipment.postage_label.label_url).to end_with(".epl2")
  end

  it 'buys a label for a ground cod shipment' do
    shipment = EasyPost::Shipment.create(
      :to_address   => ADDRESS[:california],
      :from_address => ADDRESS[:missouri],
      :parcel       => PARCEL[:dimensions]
    )
    shipment_cod = EasyPost::Shipment.create(
      :to_address   => ADDRESS[:california],
      :from_address => ADDRESS[:missouri],
      :parcel       => PARCEL[:dimensions],
      :options      => {cod_amount: 19.99}
    )
    shipment_cod.buy(rate: shipment_cod.lowest_rate("fedex", "FEDEX_GROUND"))

    expect(shipment.lowest_rate("fedex", "FEDEX_GROUND").rate.to_f).to be < (shipment_cod.lowest_rate("fedex", "FEDEX_GROUND").rate.to_f)
    expect(shipment.lowest_rate("fedex", "PRIORITY_OVERNIGHT").rate.to_f).to be < (shipment_cod.lowest_rate("fedex", "PRIORITY_OVERNIGHT").rate.to_f)
    expect(shipment_cod.postage_label.label_url).to be
  end

  it 'buys a label for a ground multi-parcel cod shipment' do
    order = EasyPost::Order.create(
      to_address: ADDRESS[:california],
      from_address: ADDRESS[:missouri],
      shipments: [{
        parcel: {length: 8, width: 6, height: 4, weight: 12},
        options: {cod_amount: 14.99}
      },{
        parcel: {length: 8, width: 6, height: 4, weight: 12},
        options: {cod_amount: 18.75}
      }]
    )
    order.buy(carrier: "fedex", service: "FEDEX_GROUND")

    expect(order).to be_an_instance_of(EasyPost::Order)
    expect(order.shipments.first).to be_an_instance_of(EasyPost::Shipment)
    expect(order.shipments[0].postage_label.label_url).to be
    expect(order.shipments[1].postage_label.label_url).to be
  end

  it 'buys a label for an express cod shipment' do
    shipment = EasyPost::Shipment.create(
      :to_address   => ADDRESS[:california],
      :from_address => ADDRESS[:missouri],
      :parcel       => PARCEL[:dimensions]
    )
    shipment_cod = EasyPost::Shipment.create(
      :to_address   => ADDRESS[:california],
      :from_address => ADDRESS[:missouri],
      :parcel       => PARCEL[:dimensions],
      :options      => {cod_amount: 19.99}
    )
    shipment_cod.buy(rate: shipment_cod.lowest_rate("fedex", "PRIORITY_OVERNIGHT"))

    expect(shipment.lowest_rate("fedex", "FEDEX_GROUND").rate.to_f).to be < (shipment_cod.lowest_rate("fedex", "FEDEX_GROUND").rate.to_f)
    expect(shipment.lowest_rate("fedex", "PRIORITY_OVERNIGHT").rate.to_f).to be < (shipment_cod.lowest_rate("fedex", "PRIORITY_OVERNIGHT").rate.to_f)
    expect(shipment_cod.postage_label.label_url).to be
  end

  it 'buys a label for an express multi-parcel cod shipment' do
    order = EasyPost::Order.create(
      to_address: ADDRESS[:california],
      from_address: ADDRESS[:missouri],
      shipments: [{
        parcel: {length: 8, width: 6, height: 4, weight: 12},
        options: {cod_amount: 14.99}
      },{
        parcel: {length: 8, width: 6, height: 4, weight: 12},
        options: {cod_amount: 18.75}
      }]
    )
    order.buy(carrier: "fedex", service: "PRIORITY_OVERNIGHT")

    expect(order).to be_an_instance_of(EasyPost::Order)
    expect(order.shipments.first).to be_an_instance_of(EasyPost::Shipment)
    expect(order.shipments[0].postage_label.label_url).to be
    expect(order.shipments[1].postage_label.label_url).to be
  end

  it 'buys a label using a thid party account number' do
    shipment = EasyPost::Shipment.create(
      :to_address   => ADDRESS[:california],
      :from_address => ADDRESS[:missouri],
      :parcel       => PARCEL[:dimensions],
      :options      => {:bill_third_party_account => "12345678"}
    )
    expect { shipment.buy(rate: shipment.lowest_rate("fedex")) }.to raise_error(EasyPost::Error, /ShippingChargesPayment Payor - The payor's account number is invalid/)
  end

  after(:all) do
    begin
      expect(@rates[:residential_evening].rate.to_i).to be > @rates[:residential].rate.to_i
      expect(@rates[:residential].rate.to_i).to be > @rates[:commercial].rate.to_i
    rescue
    end
  end

end
