require 'spec_helper'

describe 'usps domestic' do
  before(:all) do
    @first = EasyPost::Shipment.create(
      :to_address   => ADDRESS[:california],
      :from_address => ADDRESS[:missouri],
      :parcel       => PARCEL[:dimensions_light]
    )
    @first.buy(:rate => @first.lowest_rate("usps", "first"))

    @priority = EasyPost::Shipment.create(
      :to_address   => ADDRESS[:california],
      :from_address => ADDRESS[:missouri],
      :parcel       => PARCEL[:dimensions]
    )
    @priority.buy(:rate => @priority.lowest_rate("usps", "priority"))

    @return = EasyPost::Shipment.create(
      :to_address   => ADDRESS[:california],
      :from_address => ADDRESS[:missouri],
      :parcel       => PARCEL[:dimensions],
      :is_return    => true
    )
    @return.buy(:rate => @return.lowest_rate("usps", "priority"))

  end

  it 'buys a first label' do
    expect(@first).to be_an_instance_of(EasyPost::Shipment)
    expect(@first.selected_rate).to be_an_instance_of(EasyPost::Rate)
    expect(@first.selected_rate.service).to eq("First")
    expect(@first.postage_label.label_url).to end_with(".png")
    expect(@first.tracking_code).to eq("9499907123456123456781")

    label = open(@first.postage_label.label_url)
    expect(label.size).to be > 30000
  end

   it 'buys a priority label' do
    expect(@priority.selected_rate.service).to eq("Priority")
    expect(@priority.tracking_code).to eq("9499907123456123456781")

    label = open(@priority.postage_label.label_url)
    expect(label.size).to be > 30000
  end

  it 'buys a return label' do
    expect(@priority.selected_rate.service).to eq("Priority")
    expect(@priority.tracking_code).to eq("9499907123456123456781")

    label = open(@priority.postage_label.label_url)
    expect(label.size).to be > 30000
  end

  it 'omits rates for alcohol shipments' do
    shipment = EasyPost::Shipment.create(
      :to_address   => ADDRESS[:california],
      :from_address => ADDRESS[:missouri],
      :parcel       => PARCEL[:dimensions],
      :options      => {:alcohol => true}
    )
    expect { shipment.buy(rate: shipment.lowest_rate('usps')) }.to raise_exception
  end

end
