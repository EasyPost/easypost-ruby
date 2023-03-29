# frozen_string_literal: true

require 'spec_helper'

describe EasyPost::Pickup do
  describe '.create' do
    it 'creates a pickup' do
      shipment = EasyPost::Shipment.create(Fixture.one_call_buy_shipment)

      pickup_data = Fixture.basic_pickup
      pickup_data[:shipment] = shipment

      pickup = described_class.create(pickup_data)

      expect(pickup).to be_an_instance_of(described_class)
      expect(pickup.id).to match('pickup_')
      expect(pickup.pickup_rates).not_to be_nil
    end
  end

  describe '.retrieve' do
    it 'retrieves a pickup' do
      shipment = EasyPost::Shipment.create(Fixture.one_call_buy_shipment)

      pickup_data = Fixture.basic_pickup
      pickup_data[:shipment] = shipment

      pickup = described_class.create(pickup_data)

      retrieved_pickup = described_class.retrieve(pickup.id)

      expect(retrieved_pickup).to be_an_instance_of(described_class)
      expect(retrieved_pickup.to_s).to eq(pickup.to_s)
    end
  end

  describe '.all' do
    it 'retrieves all pickups' do
      pickups = described_class.all(
        page_size: Fixture.page_size,
      )

      pickups_array = pickups.pickups

      expect(pickups_array.count).to be <= Fixture.page_size
      expect(pickups.has_more).not_to be_nil
      expect(pickups_array).to all(be_an_instance_of(described_class))
    end
  end

  describe '.get_next_page' do
    it 'retrieves the next page of a collection' do
      first_page = described_class.all(
        page_size: Fixture.page_size,
      )

      begin
        next_page = described_class.get_next_page(first_page)

        first_page_first_id = first_page.pickups.first.id
        next_page_first_id = next_page.pickups.first.id

        # Did we actually get a new page?
        expect(first_page_first_id).not_to eq(next_page_first_id)
      rescue EasyPost::Error => e
        # If we get an error, make sure it's because there are no more pages.
        expect(e.message).to eq('There are no more pages to retrieve.')
      end
    end
  end

  describe '.buy' do
    it 'buys a pickup' do
      shipment = EasyPost::Shipment.create(Fixture.one_call_buy_shipment)

      pickup_data = Fixture.basic_pickup
      pickup_data[:shipment] = shipment

      pickup = described_class.create(pickup_data)

      bought_pickup = pickup.buy(
        carrier: Fixture.usps,
        service: Fixture.pickup_service,
      )

      expect(bought_pickup).to be_an_instance_of(described_class)
      expect(bought_pickup.id).to match('pickup_')
      expect(bought_pickup.confirmation).not_to be_nil
      expect(bought_pickup.status).to eq('scheduled')
    end

    it 'buys a pickup with a pickup_rate object' do
      shipment = EasyPost::Shipment.create(Fixture.one_call_buy_shipment)

      pickup_data = Fixture.basic_pickup
      pickup_data[:shipment] = shipment

      pickup = described_class.create(pickup_data)

      bought_pickup = pickup.buy(pickup.lowest_rate)

      expect(bought_pickup).to be_an_instance_of(described_class)
      expect(bought_pickup.id).to match('pickup_')
      expect(bought_pickup.confirmation).not_to be_nil
      expect(bought_pickup.status).to eq('scheduled')
    end
  end

  describe '.cancel' do
    it 'cancels a pickup' do
      shipment = EasyPost::Shipment.create(Fixture.one_call_buy_shipment)

      pickup_data = Fixture.basic_pickup
      pickup_data[:shipment] = shipment

      pickup = described_class.create(pickup_data)
      bought_pickup = pickup.buy(
        carrier: Fixture.usps,
        service: Fixture.pickup_service,
      )

      cancelled_pickup = bought_pickup.cancel

      expect(cancelled_pickup).to be_an_instance_of(described_class)
      expect(cancelled_pickup.id).to match('pickup_')
      expect(cancelled_pickup.status).to eq('canceled')
    end
  end

  describe '.lowest_rate' do
    it 'tests various usage alterations of the lowest_rate method' do
      shipment = EasyPost::Shipment.create(Fixture.one_call_buy_shipment)

      pickup_data = Fixture.basic_pickup
      pickup_data[:shipment] = shipment

      pickup = described_class.create(pickup_data)

      # Test lowest rate with no filters
      lowest_rate = pickup.lowest_rate
      expect(lowest_rate.service).to eq('NextDay')
      expect(lowest_rate.rate).to eq('0.00')
      expect(lowest_rate.carrier).to eq('USPS')

      # Test lowest rate with service filter (should error due to bad service)
      expect {
        pickup.lowest_rate([], ['BAD SERVICE'])
      }.to raise_error(EasyPost::Error, 'No rates found.')

      # Test lowest rate with carrier filter (should error due to bad carrier)
      expect {
        pickup.lowest_rate(['BAD CARRIER'], [])
      }.to raise_error(EasyPost::Error, 'No rates found.')
    end
  end
end
