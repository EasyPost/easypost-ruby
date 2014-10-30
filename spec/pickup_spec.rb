require 'spec_helper'

describe EasyPost::Pickup do

  describe '#create' do
    it 'creates a pickup and returns rates' do
      shipment = EasyPost::Shipment.create(
        :to_address   => ADDRESS[:california],
        :from_address => ADDRESS[:missouri],
        :parcel       => PARCEL[:dimensions]
      )
      shipment.buy(:rate => shipment.lowest_rate("ups", "ground"))
      pickup = EasyPost::Pickup.create(
        address: ADDRESS[:missouri],
        reference: "12345678",
        min_datetime: DateTime.now(),
        max_datetime: DateTime.now() + 14400,
        is_account_address: false,
        instructions: "",
        shipment: shipment
      )

      expect(pickup).to be_an_instance_of(EasyPost::Pickup)
      expect(pickup.pickup_rates.first).to be_an_instance_of(EasyPost::PickupRate)

    end

    it 'fails to create a pickup' do
      shipment = EasyPost::Shipment.create(
        :to_address   => ADDRESS[:california],
        :from_address => ADDRESS[:missouri],
        :parcel       => PARCEL[:dimensions]
      )
      shipment.buy(:rate => shipment.lowest_rate("ups", "ground"))
      expect { pickup = EasyPost::Pickup.create(
        address: ADDRESS[:california],
        reference: "12345678",
        max_datetime: DateTime.now() + 14400,
        is_account_address: false,
        instructions: "",
        shipment: shipment
      ) }.to raise_exception(EasyPost::Error, /Invalid request, 'min_datetime' is required./)
    end
  end

  describe '#buy' do
    it 'buys a pickup rate' do
      shipment = EasyPost::Shipment.create(
        :to_address   => ADDRESS[:california],
        :from_address => ADDRESS[:missouri],
        :parcel       => PARCEL[:dimensions]
      )
      shipment.buy(:rate => shipment.lowest_rate("ups", "ground"))
      pickup = EasyPost::Pickup.create(
        address: ADDRESS[:california],
        reference: "buy12345678",
        min_datetime: DateTime.now(),
        max_datetime: DateTime.now() + 14400,
        is_account_address: false,
        instructions: "",
        shipment: shipment
      )
      pickup.buy(pickup.pickup_rates.first)

      expect(pickup.confirmation).not_to be_empty
    end
  end

end
