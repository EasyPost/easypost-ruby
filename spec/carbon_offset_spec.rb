# frozen_string_literal: true

require 'spec_helper'

describe EasyPost::Shipment do
  describe '.create' do
    it 'creates a shipment with carbon_offset' do
      shipment_data = Fixture.basic_carbon_offset_shipment
      shipment_data[:carbon_offset] = true # set carbon_offset to true

      shipment = described_class.create(shipment_data)

      expect(shipment).to be_an_instance_of(described_class)
      expect(shipment.rates).not_to be_nil

      rate = shipment.rates.first
      expect(rate.carbon_offset).not_to be_nil
    end

    xit 'creates a one-call-buy shipment with carbon_offset' do
      # Skipping until feature goes live
      shipment_data = Fixture.one_call_buy_carbon_offset_shipment
      shipment_data[:carbon_offset] = true # set carbon_offset to true

      shipment = described_class.create(shipment_data)

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
    xit 'buys a shipment with carbon offset' do
      # Skipping until feature goes live
      shipment = described_class.create(Fixture.full_carbon_offset_shipment)

      shipment.buy(
        shipment.lowest_rate,
        true,
      )

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
end
