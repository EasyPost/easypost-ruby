# frozen_string_literal: true

require 'spec_helper'

describe EasyPost::Shipment do
  describe '.create' do
    it 'creates a shipment with carbon_offset' do
      shipment = described_class.create(Fixture.basic_carbon_offset_shipment, nil, true)

      expect(shipment).to be_an_instance_of(described_class)
      expect(shipment.rates).not_to be_nil

      rate = shipment.rates.first
      expect(rate.carbon_offset).not_to be_nil
    end

    it 'creates a one-call-buy shipment with carbon_offset' do
      shipment = described_class.create(Fixture.one_call_buy_carbon_offset_shipment, nil, true)

      expect(shipment.fees).not_to be_nil
      carbon_offset_found = false
      shipment.fees.each do |fee|
        if fee.type == 'CarbonOffsetFee'
          carbon_offset_found = true
        end
      end
      expect(carbon_offset_found).to be_truthy
    end
  end

  describe '.buy' do
    it 'buys a shipment with carbon offset' do
      shipment = described_class.create(Fixture.full_carbon_offset_shipment, nil)

      shipment.buy(shipment.lowest_rate, true)

      expect(shipment.postage_label).not_to be_nil

      expect(shipment.fees).not_to be_nil
      carbon_offset_found = false
      shipment.fees.each do |fee|
        if fee.type == 'CarbonOffsetFee'
          carbon_offset_found = true
        end
      end
      expect(carbon_offset_found).to be_truthy
    end
  end

  describe '.regenerate_rates' do
    it 'regenerates rates for a shipment with carbon offset' do
      shipment = described_class.create(Fixture.full_carbon_offset_shipment)

      shipment_with_carbon_offset = shipment.regenerate_rates(true)

      shipment_with_carbon_offset.rates.each do |rate|
        expect(rate.carbon_offset).not_to be_nil
      end
    end
  end
end
