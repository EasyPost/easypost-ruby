# frozen_string_literal: true

require 'spec_helper'

describe EasyPost::Shipment do
  describe '.create' do
    it 'creates a shipment with carbon_offset' do
      shipment = described_class.create(Fixture.basic_carbon_offset_shipment, nil, with_carbon_offset: true)

      expect(shipment).to be_an_instance_of(described_class)
      expect(shipment.rates).not_to be_nil

      rate = shipment.rates.first
      expect(rate.carbon_offset).not_to be_nil
    end

    it 'creates a one-call-buy shipment with carbon_offset' do
      shipment = described_class.create(Fixture.one_call_buy_carbon_offset_shipment, with_carbon_offset: true)

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
      shipment = described_class.create(Fixture.full_carbon_offset_shipment, with_carbon_offset: true)

      shipment.buy(shipment.lowest_rate, with_carbon_offset: true)

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

      base_rates = shipment.rates

      new_shipment_with_carbon = shipment.regenerate_rates(with_carbon_offset: true)
      new_rates_with_carbon = new_shipment_with_carbon.rates

      new_shipment_without_carbon = shipment.regenerate_rates(with_carbon_offset: false)
      new_rates_without_carbon = new_shipment_without_carbon.rates

      base_rate = base_rates[0]
      new_rate_with_carbon = new_rates_with_carbon[0]
      new_rate_without_carbon = new_rates_without_carbon[0]

      expect { base_rate.carbon_offset }.to raise_error(NoMethodError) # not present
      expect(new_rate_with_carbon.carbon_offset).not_to be_nil # present
      expect { new_rate_without_carbon.carbon_offset }.to raise_error(NoMethodError) # not present
    end
  end
end
