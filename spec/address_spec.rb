# frozen_string_literal: true

require 'spec_helper'

describe EasyPost::Address do
  describe '.create' do
    it 'creates an address' do
      address = described_class.create(Fixture.basic_address)

      expect(address).to be_an_instance_of(described_class)
      expect(address.id).to match('adr_')
      expect(address.street1).to eq('388 Townsend St')
    end

    it 'creates an address with verify_strict param' do
      address_data = Fixture.basic_address
      address_data[:verify_strict] = [true]

      address = described_class.create(address_data)

      expect(address).to be_an_instance_of(described_class)
      expect(address.id).to match('adr_')
      expect(address.street1).to eq('388 TOWNSEND ST APT 20')
    end

    it 'creates an address with verify param' do
      # We purposefully pass in slightly incorrect data to get the corrected address back once verified.
      address_data = Fixture.incorrect_address_to_verify
      address_data[:verify] = [true]

      address = described_class.create(address_data)

      expect(address).to be_an_instance_of(described_class)
      expect(address.id).to match('adr_')
      expect(address.street1).to eq('417 MONTGOMERY ST STE 500')
    end
  end

  describe '.retrieve' do
    it 'retrieves an address' do
      address = described_class.create(Fixture.basic_address)
      retrieved_address = described_class.retrieve(address.id)

      expect(retrieved_address).to be_an_instance_of(described_class)
      expect(retrieved_address.to_s).to eq(address.to_s)
    end
  end

  describe '.all' do
    it 'retrieves all addresses' do
      addresses = described_class.all(
        page_size: Fixture.page_size,
      )

      addresses_array = addresses.addresses

      expect(addresses_array.count).to be <= Fixture.page_size
      expect(addresses.has_more).not_to be_nil
      expect(addresses_array).to all(be_an_instance_of(described_class))
    end
  end

  describe '.create_and_verify' do
    it 'creates a verified address' do
      # We purposefully pass in slightly incorrect data to get the corrected address back once verified.
      address = described_class.create_and_verify(Fixture.incorrect_address_to_verify)

      expect(address).to be_an_instance_of(described_class)
      expect(address.id).to match('adr_')
      expect(address.street1).to eq('417 MONTGOMERY ST STE 500')
    end
  end

  describe '.verify' do
    it 'verifies an already created address' do
      # We purposefully pass in slightly incorrect data to get the corrected address back once verified.
      address = described_class.create(Fixture.incorrect_address_to_verify)
      verified_address = address.verify

      expect(verified_address).to be_an_instance_of(described_class)
      expect(verified_address.id).to match('adr_')
      expect(verified_address.street1).to eq('417 MONTGOMERY ST STE 500')
    end
  end
end
