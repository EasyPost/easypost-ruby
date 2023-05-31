# frozen_string_literal: true

require 'spec_helper'

describe EasyPost::Services::CarrierMetadata do
  let(:client) { EasyPost::Client.new(api_key: ENV['EASYPOST_TEST_API_KEY']) }

  describe '.retrieve_carrier_metadata' do
    it 'retrieve metadata for all carriers' do
      metadata = client.carrier_metadata.retrieve

      expect(metadata).to be_an_instance_of(Array)

      expect(metadata.find { |carrier| carrier.name == 'usps' }).not_to be_nil
      expect(metadata.find { |carrier| carrier.name == 'fedex' }).not_to be_nil
    end

    it 'retrieve metadata for a single carrier' do
      carrier = 'usps'
      types = %w[service_levels predefined_packages]

      metadata = client.carrier_metadata.retrieve(['usps'], types)

      expect(metadata).to be_an_instance_of(Array)

      first_entry = metadata.first

      # Assert we only have one carrier, and it's the one we requested
      expect(metadata.length).to eq(1)
      expect(first_entry[:name]).to eq(carrier)

      # Assert we have the requested types
      expect(first_entry).to have_attributes(service_levels: Array, predefined_packages: Array)
    end
  end
end
