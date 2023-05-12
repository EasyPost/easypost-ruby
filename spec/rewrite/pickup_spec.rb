# frozen_string_literal: true

require_relative '../spec_helper'

describe EasyPost::Services::Pickup do
  let(:client) { EasyPost::Client.new(api_key: ENV['EASYPOST_TEST_API_KEY']) }

  describe '.create' do
    it 'creates a pickup' do
      shipment = EasyPost::Shipment.create(Fixture.one_call_buy_shipment)

      pickup_data = Fixture.basic_pickup
      pickup_data[:shipment] = shipment

      pickup = client.pickup.create(pickup_data)

      expect(pickup).to be_an_instance_of(EasyPost::Models::Pickup)
      expect(pickup.id).to match('pickup_')
      expect(pickup.pickup_rates).not_to be_nil
    end
  end

  describe '.retrieve' do
    it 'retrieves a pickup' do
      shipment = EasyPost::Shipment.create(Fixture.one_call_buy_shipment)

      pickup_data = Fixture.basic_pickup
      pickup_data[:shipment] = shipment

      pickup = client.pickup.create(pickup_data)

      retrieved_pickup = client.pickup.retrieve(pickup.id)

      expect(retrieved_pickup).to be_an_instance_of(EasyPost::Models::Pickup)
      expect(retrieved_pickup.id.to_s).to eq(pickup.id.to_s)
    end
  end

  describe '.all' do
    it 'retrieves all pickups' do
      pickups = client.pickup.all(
        page_size: Fixture.page_size,
      )

      pickups_array = pickups.pickups

      expect(pickups_array.count).to be <= Fixture.page_size
      expect(pickups.has_more).not_to be_nil
      expect(pickups_array).to all(be_an_instance_of(EasyPost::Models::Pickup))
    end
  end

  describe '.get_next_page' do
    it 'retrieves the next page of a collection' do
      first_page = client.pickup.all(
        page_size: Fixture.page_size,
      )

      begin
        next_page = client.pickup.get_next_page(first_page)

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

      pickup = client.pickup.create(pickup_data)

      bought_pickup = client.pickup.buy(
        pickup.id,
        {
          carrier: Fixture.usps,
          service: 'NextDay',
        },
      )

      expect(bought_pickup).to be_an_instance_of(EasyPost::Models::Pickup)
      expect(bought_pickup.id).to match('pickup_')
      expect(bought_pickup.confirmation).not_to be_nil
      expect(bought_pickup.status).to eq('scheduled')
    end

    it 'buys a pickup with a pickup_rate object' do
      shipment = EasyPost::Shipment.create(Fixture.one_call_buy_shipment)

      pickup_data = Fixture.basic_pickup
      pickup_data[:shipment] = shipment

      pickup = client.pickup.create(pickup_data)

      bought_pickup = client.pickup.buy(pickup.id, pickup.lowest_rate)

      expect(bought_pickup).to be_an_instance_of(EasyPost::Models::Pickup)
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

      pickup = client.pickup.create(pickup_data)
      bought_pickup = client.pickup.buy(
        pickup.id,
        {
          carrier: Fixture.usps,
          service: 'NextDay',
        },
      )

      cancelled_pickup = client.pickup.cancel(bought_pickup.id)

      expect(cancelled_pickup).to be_an_instance_of(EasyPost::Models::Pickup)
      expect(cancelled_pickup.id).to match('pickup_')
      expect(cancelled_pickup.status).to eq('canceled')
    end
  end

  describe '.lowest_rate' do
    it 'tests various usage alterations of the lowest_rate method' do
      shipment = EasyPost::Shipment.create(Fixture.one_call_buy_shipment)

      pickup_data = Fixture.basic_pickup
      pickup_data[:shipment] = shipment

      pickup = client.pickup.create(pickup_data)

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
