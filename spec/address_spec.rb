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
      address_data = Fixture.incorrect_address

      # Creating normally (without specifying "verify") will make the address, perform no verifications
      address = client.address.create(address_data)

      expect(address).to be_an_instance_of(EasyPost::Models::Address)
      expect(address.verifications.instance_variable_defined?(:@delivery)).to be false

      # Creating with verify = true will make the address, perform verifications
      address_data[:verify] = true
      address = client.address.create(address_data)

      expect(address).to be_an_instance_of(EasyPost::Models::Address)

      # Delivery verification assertions
      expect(address.verifications.delivery.success).to be false
      # TODO: details is not deserializing correctly, related to the larger "double EasyPostObject" wrapping issue
      # expect(address.verifications.delivery.details).to be_empty
      expect(address.verifications.delivery.errors[0].code).to eq('E.ADDRESS.NOT_FOUND')
      expect(address.verifications.delivery.errors[0].field).to eq('address')
      expect(address.verifications.delivery.errors[0].suggestion).to be nil
      expect(address.verifications.delivery.errors[0].message).to eq('Address not found')

      # Zip4 verification assertions
      expect(address.verifications.zip4.success).to be false
      expect(address.verifications.zip4.details).to be nil
      expect(address.verifications.zip4.errors[0].code).to eq('E.ADDRESS.NOT_FOUND')
      expect(address.verifications.zip4.errors[0].field).to eq('address')
      expect(address.verifications.zip4.errors[0].suggestion).to be nil
      expect(address.verifications.zip4.errors[0].message).to eq('Address not found')
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
      address_data = Fixture.incorrect_address

      # Creating normally (without specifying "verify") will make the address, perform no verifications
      address = client.address.create(address_data)

      expect(address).to be_an_instance_of(EasyPost::Models::Address)
      expect(address.verifications.instance_variable_defined?(:@delivery)).to be false

      # Creating with verify = true will make the address, perform verifications
      address_data[:verify] = [true]
      address = client.address.create(address_data)

      expect(address).to be_an_instance_of(EasyPost::Models::Address)
      expect(address.verifications.delivery.success).to be false
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
      expect(addresses[EasyPost::InternalUtilities::Constants::FILTERS_KEY]).to be_a(Hash)

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

        # Verify that filters are being passed along for internal reference
        expect(first_page[EasyPost::InternalUtilities::Constants::FILTERS_KEY]).to eq(
          next_page[EasyPost::InternalUtilities::Constants::FILTERS_KEY],
        )
      rescue EasyPost::Errors::EndOfPaginationError => e
        # If we get an error, make sure it's because there are no more pages.
        expect(e.message).to eq(EasyPost::Constants::NO_MORE_PAGES)
      end
    end
  end

  describe '.create_and_verify' do
    it 'creates a verified address' do
      address = client.address.create_and_verify(Fixture.ca_address1)

      expect(address).to be_an_instance_of(EasyPost::Models::Address)
      expect(address.id).to match('adr_')
      expect(address.street1).to eq('388 TOWNSEND ST APT 20')
    end

    it 'throws an error for invalid address verification' do
      address_data = Fixture.incorrect_address

      # Creates with verify = true behind the scenes, will make the address, perform verifications
      # Will throw an error if the address is invalid
      client.address.create_and_verify(address_data)
    rescue EasyPost::Errors::InvalidRequestError => e
      expect(e.message).to eq('Unable to verify address.')
    end
  end

  describe '.verify' do
    it 'verifies an already created address' do
      # We purposefully pass in slightly incorrect data to get the corrected address back once verified.
      address = client.address.create(Fixture.ca_address1)
      verified_address = client.address.verify(address.id)

      expect(verified_address).to be_an_instance_of(EasyPost::Models::Address)
      expect(verified_address.id).to match('adr_')
      expect(verified_address.street1).to eq('388 TOWNSEND ST APT 20')
    end

    it 'throws an error for invalid address verification' do
      address = client.address.create(street1: 'invalid')
      client.address.verify(address.id)
    rescue EasyPost::Errors::InvalidRequestError => e
      expect(e.message).to eq('Unable to verify address.')
    end
  end
end
