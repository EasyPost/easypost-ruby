require 'spec_helper'

describe EasyPost::Shipment do

  describe '#create' do
    it 'creates a shipment object' do
      from_address = EasyPost::Address.create(
        :name => "Benchmark Merchandising",
        :street1 => "329 W 18th Street",
        :city => "Chicago",
        :state => "IL",
        :zip => "60616"
      )
      to_address = EasyPost::Address.create(
        :street1 => "902 Broadway 4th Floor",
        :city => "New York",
        :state => "NY",
        :zip => "10010"
      )
      parcel = EasyPost::Parcel.create(
        :weight => 7.2,
        :height => 2,
        :width => 7.5,
        :length => 10.5
      )

      shipment = EasyPost::Shipment.create(
        :to_address => to_address,
        :from_address => from_address,
        :parcel => parcel
      )
      expect(shipment).to be_an_instance_of(EasyPost::Shipment)
      expect(shipment.from_address).to be_an_instance_of(EasyPost::Address)

    end
  end

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
        :rate => shipment.lowest_rate('usps')
      )
      expect(shipment.postage_label.label_url.length).to be > 0
    end

    it 'purchases postage for a domestic shipment' do
      to_address = address_california
      from_address = address_missouri
      expect(to_address).to be_an_instance_of(EasyPost::Address)
      expect(from_address).to be_an_instance_of(EasyPost::Address)

      parcel = parcel_dimensions
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

  describe '#stamp' do
    it 'returns a stamp for a domestic shipment' do
      to_address = address_california
      from_address = address_missouri
      expect(to_address).to be_an_instance_of(EasyPost::Address)
      expect(from_address).to be_an_instance_of(EasyPost::Address)

      parcel = parcel_dimensions
      expect(parcel).to be_an_instance_of(EasyPost::Parcel)

      shipment = EasyPost::Shipment.create(
        :to_address => to_address,
        :from_address => from_address,
        :parcel => parcel
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
      to_address = address_california
      from_address = address_missouri
      expect(to_address).to be_an_instance_of(EasyPost::Address)
      expect(from_address).to be_an_instance_of(EasyPost::Address)

      parcel = parcel_dimensions
      expect(parcel).to be_an_instance_of(EasyPost::Parcel)

      shipment = EasyPost::Shipment.create(
        :to_address => to_address,
        :from_address => from_address,
        :parcel => parcel
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
          :from_address => address_california,
          :to_address   => address_missouri,
          :parcel => parcel_dimensions
        )
      end

      it 'filters negative services' do
        rate = @shipment.lowest_rate('USPS', '!MediaMail, !LibraryMail')

        expect(rate.service).to eql('ParcelSelect')
      end
    end
  end

  describe '#track_with_code' do
    it 'returns tracking information' do
      tracking = EasyPost::Shipment.track_with_code({
        :carrier       => 'usps',
        :tracking_code => '9499907123456123456781'
      })
      expect(tracking).to be_an_instance_of(Array)
      expect(tracking[0][:status].length).to be > 0
      expect(tracking[0][:message].length).to be > 0
    end
  end

end
