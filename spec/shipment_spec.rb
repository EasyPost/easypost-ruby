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
      expect(shipment.options.fulfiller_order_items.first)
        .to be_an_instance_of(EasyPost::EasyPostObject)
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
        :to_address => ADDRESS[:missouri],
        :from_address => ADDRESS[:california],
        :parcel => PARCEL[:dimensions]
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
        :to_address => ADDRESS[:missouri],
        :from_address => ADDRESS[:california],
        :parcel => PARCEL[:dimensions]
      )
      expect(shipment).to be_an_instance_of(EasyPost::Shipment)

      rate = shipment.rates.first
      rate_hash = { id: rate.id }

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
        :to_address => ADDRESS[:missouri],
        :from_address => ADDRESS[:california],
        :parcel => PARCEL[:dimensions]
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
      let (:shipment) {
        EasyPost::Shipment.create(
          to_address: EasyPost::Address.create(ADDRESS[:missouri]),
          from_address: ADDRESS[:california],
          parcel: EasyPost::Parcel.create(PARCEL[:dimensions])
        )
      }

      it 'filters negative services' do
        rate = shipment.lowest_rate('USPS', '!MediaMail, !LibraryMail')
        expect(rate.service).to eql('ParcelSelect')
      end

      it 'doesn\'t modify carriers array' do
        carriers = %w(USPS)
        shipment.lowest_rate(carriers)
        expect(carriers).to eq(%w(USPS))
      end

      it 'doesn\'t modify services array' do
        services = %w(ParcelSelect)
        shipment.lowest_rate('USPS', services)
        expect(services).to eq(%w(ParcelSelect))
      end
    end
  end

  describe '#rerate' do
    let(:shipment) {
        EasyPost::Shipment.create(
          to_address: EasyPost::Address.create(ADDRESS[:missouri]),
          from_address: ADDRESS[:california],
          parcel: EasyPost::Parcel.create(PARCEL[:dimensions])
        )
    }

    it 'fetches new rates' do
      existing_rate_ids = shipment.rates.map(&:id)
      shipment.regenerate_rates
      new_rate_ids = shipment.rates.map(&:id)
      expect(new_rate_ids).not_to eq(existing_rate_ids)
    end
  end

  describe '#retrieve' do
    # This was a bug in python.
    it 'retrieves shipment by tracking_code and correctly sets ID field' do
      tracking_code = "CM218228743US"
      shipment = EasyPost::Shipment.retrieve(tracking_code)

      expect(shipment.id).not_to eq(tracking_code)
    end
  end

  describe '#smartrate' do
    it 'retrieves the smartrates for a shipment' do
      shipment = EasyPost::Shipment.create(
        :to_address => ADDRESS[:missouri],
        :from_address => ADDRESS[:california],
        :parcel => PARCEL[:dimensions]
      )
      expect(shipment.rates).not_to be nil

      smartrates = shipment.get_smartrates
      expect(shipment.rates[0]['id']).to eq(smartrates[0]['id'])
      expect(smartrates[0]['time_in_transit']['percentile_50']).to eq(1)
      expect(smartrates[0]['time_in_transit']['percentile_75']).to eq(2)
      expect(smartrates[0]['time_in_transit']['percentile_85']).to eq(2)
      expect(smartrates[0]['time_in_transit']['percentile_90']).to eq(3)
      expect(smartrates[0]['time_in_transit']['percentile_95']).to eq(3)
      expect(smartrates[0]['time_in_transit']['percentile_97']).to eq(4)
      expect(smartrates[0]['time_in_transit']['percentile_99']).to eq(5)
    end
  end
end
