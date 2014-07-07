require 'spec_helper'

describe 'ups domestic' do
  before(:all) do
    @rates = {}
  end

  it 'buys an air label' do
    shipment = EasyPost::Shipment.create(
      :to_address   => ADDRESS[:california],
      :from_address => ADDRESS[:missouri],
      :parcel       => PARCEL[:dimensions]
    )
    shipment.buy(:rate => shipment.lowest_rate("ups", "NextDayAir"))
    label = open(shipment.postage_label.label_url)


    expect(shipment).to be_an_instance_of(EasyPost::Shipment)
    expect(shipment.selected_rate).to be_an_instance_of(EasyPost::Rate)
    expect(shipment.selected_rate.service).to eq("NextDayAir")
    expect(shipment.postage_label.label_url).to end_with(".png")
    expect(shipment.tracking_code).to start_with("1Z")
    expect(label.size).to be > 5000

    @rates[:next_day_air] = shipment.selected_rate
  end

   it 'buys a residential ground label' do
    shipment = EasyPost::Shipment.create(
      :to_address   => ADDRESS[:california],
      :from_address => ADDRESS[:missouri],
      :parcel       => PARCEL[:dimensions],
      :options      => {:residential_to_address => true}
    )
    shipment.buy(:rate => shipment.lowest_rate("ups", "Ground"))
    label = open(shipment.postage_label.label_url)

    expect(shipment.selected_rate.service).to eq("Ground")
    expect(shipment.tracking_code).to start_with("1Z")
    expect(label.size).to be > 5000

    @rates[:ground] = shipment.selected_rate
  end

  it 'buys a label for an alcoholic shipment and epl2 label' do
    shipment = EasyPost::Shipment.create(
      :to_address   => ADDRESS[:california],
      :from_address => ADDRESS[:missouri],
      :parcel       => PARCEL[:dimensions],
      :options      => {alcohol: true, label_format: "epl2"}
    )
    shipment.buy(:rate => shipment.lowest_rate("ups", "Ground"))

    expect(shipment.postage_label.label_url).to end_with(".epl2")
  end

  after(:all) do
    begin
      expect(@rates[:next_day_air].rate.to_i).to be > @rates[:ground].rate.to_i
    rescue
    end
  end

end
