# frozen_string_literal: true

require 'spec_helper'

describe EasyPost::Address do
  describe '.create_and_verify' do
    context 'when a valid address' do
      it 'works correctly' do
        address = described_class.create_and_verify(ADDRESS[:california])
        expect(address.street1).to eq '164 TOWNSEND ST UNIT 1'
        expect(address.verifications.zip4.success).to be true
        expect(address.verifications.delivery.success).to be true
      end
    end

    context 'when a successful response without an address' do
      it 'raises an error' do
        allow(EasyPost).to receive(:make_request).and_return({})
        expect {
          described_class.create_and_verify(ADDRESS[:california])
        }.to raise_error EasyPost::Error, /Unable to verify addres/
      end
    end
  end

  describe '#create' do
    it 'creates an address object' do
      address = described_class.create(ADDRESS[:california])

      expect(address).to be_an_instance_of(described_class)
      expect(address.company).to eq('EasyPost')
    end
  end

  describe '#verify' do
    it 'verifies an address with an error' do
      address = described_class.create(
        ADDRESS[:california].reject { |k, _v| [:street1, :company].include?(k) },
      )

      expect(address.street1).to be_nil
      expect(address.street2).to eq('Unit 1')
      expect(address.city).to eq('San Francisco')
      expect(address.state).to eq('CA')
      expect(address.zip).to eq('94107')
      expect(address.country).to eq('US')

      expect {
        address.verify
      }.to raise_error EasyPost::Error, /Unable to verify addres/
    end

    it 'verifies an address without message' do
      address = described_class.create(ADDRESS[:california])

      verified_address = address.verify
      expect(verified_address).to be_an_instance_of(described_class)
      expect(verified_address[:message]).to be_nil
    end

    it 'verifies an address using a carrier' do
      address = described_class.create(ADDRESS[:california])

      expect(address.company).to eq('EasyPost')
      expect(address.street1).to eq('164 Townsend Street')
      expect(address.city).to eq('San Francisco')
      expect(address.state).to eq('CA')
      expect(address.zip).to eq('94107')
      expect(address.country).to eq('US')

      verified_address = address.verify(carrier: :usps)
      expect(verified_address).to be_an_instance_of(described_class)
    end

    it 'is not able to verify address' do
      address = described_class.create(
        company: 'Simpler Postage Inc',
        street1: '388 Junk Teerts',
        street2: 'Apt 20',
        city: 'San Francisco',
        state: 'CA',
        zip: '941abc07',
      )

      expect {
        address.verify
      }.to raise_error(EasyPost::Error, /Unable to verify addres/)
    end
  end
end
