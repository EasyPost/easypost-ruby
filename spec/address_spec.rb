# frozen_string_literal: true

require 'spec_helper'

describe EasyPost::Services::Address do
  let(:client) { EasyPost::Client.new(api_key: ENV['EASYPOST_TEST_API_KEY']) }

  describe 'address service' do
    it 'creates an address' do
      address = client.address.create(Fixture.ca_address1)

      expect(address.id).to match('adr_')
      expect(address.street1).to eq('388 Townsend St')
      expect(address).to be_an_instance_of(EasyPost::Models::Address)
    end

    it 'creates an address with verify param' do
      # We purposefully pass in slightly incorrect data to get the corrected address back once verified.
      address_data = Fixture.incorrect_address
      address_data[:verify] = true

      address = client.address.create(address_data)

      expect(address).to be_an_instance_of(EasyPost::Models::Address)
      expect(address.id).to match('adr_')
      expect(address.street1).to eq('417 MONTGOMERY ST FL 5')
      expect(address.verifications.zip4.errors[0].message).to eq('Invalid secondary information(Apt/Suite#)')
    end

    it 'creates an address with verify_strict param' do
      address_data = Fixture.ca_address1
      address_data[:verify_strict] = true

      address = client.address.create(address_data)

      expect(address).to be_an_instance_of(EasyPost::Models::Address)
      expect(address.id).to match('adr_')
      expect(address.street1).to eq('388 TOWNSEND ST APT 20')
    end

    it 'creates an address with an array verify param' do
      # We purposefully pass in slightly incorrect data to get the corrected address back once verified.
      address_data = Fixture.incorrect_address
      address_data[:verify] = [true]

      address = client.address.create(address_data)

      expect(address).to be_an_instance_of(EasyPost::Models::Address)
      expect(address.id).to match('adr_')
      expect(address.street1).to eq('417 MONTGOMERY ST FL 5')
      expect(address.verifications.zip4.errors[0].message).to eq('Invalid secondary information(Apt/Suite#)')
    end
  end

  describe '.retrieve' do
    it 'retrieves an address' do
      address = client.address.create(Fixture.ca_address1)
      retrieved_address = client.address.retrieve(address.id)

      expect(retrieved_address).to be_an_instance_of(EasyPost::Models::Address)
      expect(retrieved_address.id.to_s).to eq(address.id.to_s)
    end
  end

  describe '.all' do
    it 'retrieves all addresses' do
      addresses = client.address.all(
        page_size: Fixture.page_size,
      )

      addresses_array = addresses.addresses
      expect(addresses_array.count).to be <= Fixture.page_size
      expect(addresses.has_more).not_to be_nil
      expect(addresses_array).to all(be_an_instance_of(EasyPost::Models::Address))
    end
  end

  describe '.get_next_page' do
    it 'retrieves the next page of a collection' do
      first_page = client.address.all(
        page_size: Fixture.page_size,
      )

      begin
        next_page = client.address.get_next_page(first_page)

        first_page_first_id = first_page.addresses.first.id
        next_page_first_id = next_page.addresses.first.id

        # Did we actually get a new page?
        expect(first_page_first_id).not_to eq(next_page_first_id)
      rescue EasyPost::Exceptions::EndOfPaginationError => e
        # If we get an error, make sure it's because there are no more pages.
        expect(e.message).to eq(EasyPost::Constants::ErrorMessages::NO_MORE_PAGES)
      end
    end
  end

  describe '.create_and_verify' do
    it 'creates a verified address' do
      # We purposefully pass in slightly incorrect data to get the corrected address back once verified.
      address = client.address.create_and_verify(Fixture.incorrect_address)

      expect(address).to be_an_instance_of(EasyPost::Models::Address)
      expect(address.id).to match('adr_')
      expect(address.street1).to eq('417 MONTGOMERY ST FL 5')
    end
  end

  describe '.verify' do
    it 'verifies an already created address' do
      # We purposefully pass in slightly incorrect data to get the corrected address back once verified.
      address = client.address.create(Fixture.incorrect_address)
      verified_address = client.address.verify(address.id)

      expect(verified_address).to be_an_instance_of(EasyPost::Models::Address)
      expect(verified_address.id).to match('adr_')
      expect(verified_address.street1).to eq('417 MONTGOMERY ST FL 5')
    end

    it 'throws an error for invalid address verification' do
      address = client.address.create(street1: 'invalid')
      client.address.verify(address.id)
    rescue EasyPost::Exceptions::InvalidRequestError => e
      expect(e.message).to eq('Unable to verify address.')
    end
  end
end
