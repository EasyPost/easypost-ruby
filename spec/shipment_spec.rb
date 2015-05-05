require 'spec_helper'

describe EasyPost::Shipment do
  describe '#create' do
    it 'creates a shipment object' do

      shipment = EasyPost::Shipment.create(
        to_address: ADDRESS[:california],
        from_address: EasyPost::Address.create(ADDRESS[:missouri]),
        parcel: EasyPost::Parcel.create(PARCEL[:dimensions])
      )
      expect(shipment).to be_an_instance_of(EasyPost::Shipment)
      expect(shipment.from_address).to be_an_instance_of(EasyPost::Address)

    end
  end

  describe '#buy' do
    context 'with valid attributes' do
      it 'purchases postage for an international shipment' do

        shipment = EasyPost::Shipment.create(
          to_address: EasyPost::Address.create(ADDRESS[:canada]),
          from_address: ADDRESS[:california],
          parcel: EasyPost::Parcel.create(PARCEL[:dimensions]),
          customs_info: EasyPost::CustomsInfo.create(CUSTOMS_INFO[:shirt])
        )
        expect(shipment).to be_an_instance_of(EasyPost::Shipment)

        shipment.buy(
          rate: shipment.lowest_rate("usps")
        )
        expect(shipment.postage_label.label_url.length).to be > 0
      end

      it 'purchases postage for a domestic shipment' do
        shipment = EasyPost::Shipment.create(
          to_address: EasyPost::Address.create(ADDRESS[:missouri]),
          from_address: ADDRESS[:california],
          parcel: EasyPost::Parcel.create(PARCEL[:dimensions])
        )
        expect(shipment).to be_an_instance_of(EasyPost::Shipment)

        shipment.buy(
          rate: shipment.lowest_rate("usps")
        )
        expect(shipment.postage_label.label_url.length).to be > 0
      end
    end

    context 'with invalid from address' do
      let(:invalid_from_address) { ADDRESS[:california].clone.tap { |addr| addr[:phone] = '33' } }

      it 'throws error', k: true do
        shipment = EasyPost::Shipment.create(
            to_address: EasyPost::Address.create(ADDRESS[:canada]),
            from_address: invalid_from_address,
            parcel: EasyPost::Parcel.create(PARCEL[:dimensions]),
            customs_info: EasyPost::CustomsInfo.create(CUSTOMS_INFO[:shirt])
        )

        expect { shipment.buy(rate: shipment.lowest_rate("usps")) }.
            to raise_error(EasyPost::Error)
      end
    end
  end

  it 'creates and returns a tracker with shipment purchase' do
      shipment = EasyPost::Shipment.create(
        :to_address   => ADDRESS[:missouri],
        :from_address => ADDRESS[:california],
        :parcel       => PARCEL[:dimensions]
      )
      expect(shipment).to be_an_instance_of(EasyPost::Shipment)

      shipment.buy(
        :rate => shipment.lowest_rate("usps")
      )

      tracker = shipment.tracker
      expect(tracker.shipment_id).to eq(shipment.id)
      expect(tracker.tracking_details.length).to be > 0
  end

  describe '#stamp' do
    it 'returns a stamp for a domestic shipment' do
      shipment = EasyPost::Shipment.create(
        to_address: EasyPost::Address.create(ADDRESS[:missouri]),
        from_address: ADDRESS[:california],
        parcel: EasyPost::Parcel.create(PARCEL[:dimensions])
      )
      expect(shipment).to be_an_instance_of(EasyPost::Shipment)

      shipment.buy(
        rate: shipment.lowest_rate(['USPS', 'UPS'], 'priority, express')
      )

      stamp_url = shipment.stamp

      expect(stamp_url.length).to be > 0
    end
  end

  describe '#barcode' do
    it 'returns a barcode for a domestic shipment' do
      shipment = EasyPost::Shipment.create(
        to_address: EasyPost::Address.create(ADDRESS[:missouri]),
        from_address: ADDRESS[:california],
        parcel: EasyPost::Parcel.create(PARCEL[:dimensions])
      )
      expect(shipment).to be_an_instance_of(EasyPost::Shipment)

      shipment.buy(
        rate: shipment.lowest_rate('usps', ['Priority'])
      )

      barcode_url = shipment.barcode

      expect(barcode_url.length).to be > 0
    end
  end

  describe '#lowest_rate' do
    context 'domestic shipment' do
      before :all do
        @shipment = EasyPost::Shipment.create(
          to_address: EasyPost::Address.create(ADDRESS[:missouri]),
        from_address: ADDRESS[:california],
        parcel: EasyPost::Parcel.create(PARCEL[:dimensions])
      )
      end

      it 'filters negative services' do
        rate = @shipment.lowest_rate('USPS', '!MediaMail, !LibraryMail')

        expect(rate.service).to eql('ParcelSelect')
      end
    end
  end
end
