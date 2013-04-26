require 'spec_helper'

describe EasyPost::Shipment do

  describe '#buy' do
    it 'purchases postage for an international shipment' do
      to_address = address_canada
      from_address = address_california
      expect(to_address).to be_an_instance_of(EasyPost::Address)
      expect(from_address).to be_an_instance_of(EasyPost::Address)

      parcel = parcel_dimensions
      expect(parcel).to be_an_instance_of(EasyPost::Parcel)

      customs_info = customs_info_poor
      expect(customs_info).to be_an_instance_of(EasyPost::CustomsInfo)
      
      shipment = EasyPost::Shipment.create(
        :to_address => to_address,
        :from_address => from_address,
        :parcel => parcel,
        :customs_info => customs_info
      )
      expect(shipment).to be_an_instance_of(EasyPost::Shipment)

      shipment.buy(
        :rate => shipment.rates[0]
      )
      expect(shipment.postage_label.label_url.length).to be > 0
    end

    it 'purchases postage for a domestic shipment' do
      to_address = address_california
      from_address = address_missouri
      expect(to_address).to be_an_instance_of(EasyPost::Address)
      expect(from_address).to be_an_instance_of(EasyPost::Address)

      parcel = parcel_package
      expect(parcel).to be_an_instance_of(EasyPost::Parcel)

      shipment = EasyPost::Shipment.create(
        :to_address => to_address,
        :from_address => from_address,
        :parcel => parcel
      )
      expect(shipment).to be_an_instance_of(EasyPost::Shipment)

      shipment.buy(
        :rate => shipment.lowest_rate
      )
      expect(shipment.postage_label.label_url.length).to be > 0
    end
  end

    
end