# frozen_string_literal: true

require 'spec_helper'

describe EasyPost::Order do
  describe '.create' do
    it 'creates an order' do
      order = described_class.create(Fixture.basic_order)

      expect(order).to be_an_instance_of(described_class)
      expect(order.id).to match('order_')
      expect(order.rates).not_to be_nil
    end
  end

  describe '.retrieve' do
    it 'retrieves an order' do
      order = described_class.create(Fixture.basic_order)
      retrieved_order = described_class.retrieve(order.id)

      expect(retrieved_order).to be_an_instance_of(described_class)
      expect(retrieved_order.id).to eq(order.id)
    end
  end

  describe '.all' do
    it 'raises not implemented error' do
      expect { described_class.all }.to raise_error(NotImplementedError)
    end
  end

  describe '.get_rates' do
    it 'retrieves rates for an order' do
      order = described_class.create(Fixture.basic_order)
      rates = order.get_rates

      rates_array = rates.rates

      expect(rates_array).to be_an_instance_of(Array)
      expect(rates_array).to all(be_an_instance_of(EasyPost::Rate))
    end
  end

  describe '.buy' do
    it 'buys an order' do
      order = described_class.create(Fixture.basic_order)

      order.buy(
        carrier: Fixture.usps,
        service: Fixture.usps_service,
      )

      shipments_array = order.shipments

      shipments_array.each do |shipment|
        expect(shipment.postage_label).not_to be_nil
      end
    end
  end
end
