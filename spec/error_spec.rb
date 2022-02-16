# frozen_string_literal: true

require 'spec_helper'

describe EasyPost::Error do
  describe 'error' do
    it 'throws an error on bad shipment data' do
      expect { EasyPost::Shipment.create }.to raise_error(described_class)
    end

    it 'converts an error to a string' do
      EasyPost::Shipment.create
    rescue described_class => e
      # rubocop:disable Layout/LineLength
      expect(e.to_s).to eq('SHIPMENT.INVALID_PARAMS (422): Unable to create shipment, one or more parameters were invalid. [{"to_address"=>"Required and missing."}, {"from_address"=>"Required and missing."}]')
      # rubocop:enable Layout/LineLength
    end
  end
end
