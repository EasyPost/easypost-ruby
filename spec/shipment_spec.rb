require 'spec_helper'

describe EasyPost::Shipment do

  describe '#create' do
    it 'creates a shipment object' do

      shipment = EasyPost::Shipment.create(
        :to_address   => ADDRESS[:california],
        :from_address => ADDRESS[:missouri],
        :parcel       => PARCEL[:dimensions]
      )
      expect(shipment).to be_an_instance_of(EasyPost::Shipment)
      expect(shipment.from_address).to be_an_instance_of(EasyPost::Address)

    end
  end

  describe '#buy' do
    it 'purchases postage for an international shipment' do

      shipment = EasyPost::Shipment.create(
        :to_address   => ADDRESS[:canada],
        :from_address => ADDRESS[:california],
        :parcel       => PARCEL[:dimensions],
        :customs_info => CUSTOMS_INFO[:shirt]
      )
      expect(shipment).to be_an_instance_of(EasyPost::Shipment)

      shipment.buy(
        :rate => shipment.lowest_rate("usps")
      )
      expect(shipment.postage_label.label_url.length).to be > 0
    end

    it 'purchases postage for a domestic shipment' do
      shipment = EasyPost::Shipment.create(
        :to_address   => ADDRESS[:missouri],
        :from_address => ADDRESS[:california],
        :parcel       => PARCEL[:dimensions]
      )
      expect(shipment).to be_an_instance_of(EasyPost::Shipment)

      shipment.buy(
        :rate => shipment.lowest_rate("usps")
      )
      expect(shipment.postage_label.label_url.length).to be > 0
    end
  end

  describe '#stamp' do
    it 'returns a stamp for a domestic shipment' do
      shipment = EasyPost::Shipment.create(
        :to_address   => ADDRESS[:missouri],
        :from_address => ADDRESS[:california],
        :parcel       => PARCEL[:dimensions]
      )
      expect(shipment).to be_an_instance_of(EasyPost::Shipment)

      shipment.buy(
        :rate => shipment.lowest_rate(['USPS', 'UPS'], 'priority, express')
      )

      stamp_url = shipment.stamp

      expect(stamp_url.length).to be > 0
    end
  end

  describe '#barcode' do
    it 'returns a barcode for a domestic shipment' do
      shipment = EasyPost::Shipment.create(
        :to_address   => ADDRESS[:missouri],
        :from_address => ADDRESS[:california],
        :parcel       => PARCEL[:dimensions]
      )
      expect(shipment).to be_an_instance_of(EasyPost::Shipment)

      shipment.buy(
        :rate => shipment.lowest_rate('usps', ['Priority'])
      )

      barcode_url = shipment.barcode

      expect(barcode_url.length).to be > 0
    end
  end

  describe '#lowest_rate' do
    context 'domestic shipment' do
      before :all do
        @shipment = EasyPost::Shipment.create(
        :to_address   => ADDRESS[:missouri],
        :from_address => ADDRESS[:california],
        :parcel       => PARCEL[:dimensions]
      )
      end

      it 'filters negative services' do
        rate = @shipment.lowest_rate('USPS', '!MediaMail, !LibraryMail')

        expect(rate.service).to eql('ParcelSelect')
      end
    end
  end

end
