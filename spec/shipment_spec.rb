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

    it 'creates a shipment object when options hash contains id' do

      shipment = EasyPost::Shipment.create(
        to_address: ADDRESS[:california],
        from_address: EasyPost::Address.create(ADDRESS[:missouri]),
        parcel: EasyPost::Parcel.create(PARCEL[:dimensions]),
        options: OPTIONS[:mws]
      )
      expect(shipment).to be_an_instance_of(EasyPost::Shipment)
      expect(shipment.options.fulfiller_order_items.first).to be_an_instance_of(EasyPost::EasyPostObject)

    end
  end

  describe '#buy' do
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
    end

    it 'purchases postage when only a rate id is provided' do
        shipment = EasyPost::Shipment.create(
          :to_address   => ADDRESS[:missouri],
          :from_address => ADDRESS[:california],
          :parcel       => PARCEL[:dimensions]
        )
        expect(shipment).to be_an_instance_of(EasyPost::Shipment)

        rate = shipment.rates.first
        rate_hash = {id: rate.id}

        shipment.buy(
          :rate => rate_hash
        )

        expect(shipment.postage_label.label_url.length).to be > 0
        tracker = shipment.tracker
        expect(tracker.shipment_id).to eq(shipment.id)
    end
  end

  describe '#insure' do
    it 'buys and insures a shipments' do
      shipment = EasyPost::Shipment.create(
        :to_address   => ADDRESS[:missouri],
        :from_address => ADDRESS[:california],
        :parcel       => PARCEL[:dimensions]
      )
      expect(shipment).to be_an_instance_of(EasyPost::Shipment)

      shipment.buy(
        :rate => shipment.lowest_rate("usps")
      )

      shipment.insure(amount: 100)

      expect(shipment.insurance).to eq("100.00")
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

      it 'doesn\'t modify carriers array' do
        carriers = %w(USPS)
        @shipment.lowest_rate(carriers)
        expect(carriers).to eq(%w(USPS))
      end

      it 'doesn\'t modify services array' do
        services = %w(ParcelSelect)
        @shipment.lowest_rate('USPS', services)
        expect(services).to eq(%w(ParcelSelect))
      end
    end
  end

  describe '#retrieve' do
    it 'retrieves shipment by tracking_code and correctly sets ID field (this was a bug in python)' do
      tracking_code = "LN123456789US"
      shipment = EasyPost::Shipment.retrieve(tracking_code)

      expect(shipment.id).not_to eq(tracking_code)
    end
  end
end
