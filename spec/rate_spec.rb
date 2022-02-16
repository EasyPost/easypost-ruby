# frozen_string_literal: true

require 'spec_helper'

describe EasyPost::Rate do
  describe '.retrieve' do
    it 'retrieves a rate' do
      shipment = EasyPost::Shipment.create(Fixture.basic_shipment)

      rate = described_class.retrieve(shipment.rates[0].id)

      expect(rate).to be_an_instance_of(described_class)
      expect(rate.id).to match('rate')
    end
  end

  describe '.all' do
    it 'raises not implemented error' do
      expect { described_class.all }.to raise_error(NotImplementedError)
    end
  end
end
