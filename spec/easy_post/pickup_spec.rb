# frozen_string_literal: true

require 'spec_helper'

describe EasyPost::Pickup do
  let(:noon_tomorrow) { (Date.today + 1).to_datetime + Rational(12, 24) }
  let!(:shipment) do
    EasyPost::Shipment.create(
      to_address: ADDRESS[:california],
      from_address: ADDRESS[:missouri],
      parcel: PARCEL[:dimensions],
    )
  end

  describe '#create' do
    it 'creates a pickup and returns rates' do
      shipment.buy(rate: shipment.lowest_rate('UPS', 'NextDayAirEarlyAM'))
      pickup = described_class.create(
        address: ADDRESS[:missouri],
        reference: '12345678',
        min_datetime: noon_tomorrow,
        max_datetime: noon_tomorrow,
        is_account_address: false,
        instructions: 'At the front door.',
        shipment: shipment,
      )

      expect(pickup).to be_an_instance_of(described_class)
      expect(pickup.pickup_rates.first).to be_an_instance_of(EasyPost::PickupRate)
    end

    it 'fails to create a pickup' do
      shipment.buy(rate: shipment.lowest_rate('UPS', 'NextDayAirEarlyAM'))
      expect {
        described_class.create(
          address: ADDRESS[:california],
          reference: '12345678',
          max_datetime: noon_tomorrow,
          is_account_address: false,
          instructions: 'At the front door.',
          shipment: shipment,
        )
      }.to raise_exception(EasyPost::Error, /Invalid request, 'min_datetime' is required./)
    end
  end

  describe '#buy' do
    it 'buys a pickup rate' do
      shipment.buy(rate: shipment.lowest_rate('UPS', 'NextDayAirEarlyAM'))
      pickup = described_class.create(
        address: ADDRESS[:california],
        reference: 'buy12345678',
        min_datetime: noon_tomorrow,
        max_datetime: noon_tomorrow,
        is_account_address: false,
        instructions: 'At the front door.',
        shipment: shipment,
      )
      pickup.buy(pickup.pickup_rates.first)

      expect(pickup.confirmation).not_to be_empty
    end
  end

  describe '#cancel' do
    it 'cancels a pickup' do
      shipment.buy(rate: shipment.lowest_rate('UPS', 'NextDayAirEarlyAM'))
      pickup = described_class.create(
        address: ADDRESS[:california],
        reference: 'buy12345678',
        min_datetime: noon_tomorrow,
        max_datetime: noon_tomorrow,
        is_account_address: false,
        instructions: 'At the front door.',
        shipment: shipment,
      )
      pickup.buy(pickup.pickup_rates.first)

      expect(pickup.status).to eq('scheduled')

      pickup.cancel

      expect(pickup.status).to eq('canceled')
    end
  end
end
