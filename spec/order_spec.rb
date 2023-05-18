# frozen_string_literal: true

require 'spec_helper'

describe EasyPost::Services::Order do
  let(:client) { EasyPost::Client.new(api_key: ENV['EASYPOST_TEST_API_KEY']) }

  describe '.create' do
    it 'creates an order' do
      order = client.order.create(Fixture.basic_order)

      expect(order).to be_an_instance_of(EasyPost::Models::Order)
      expect(order.id).to match('order_')
      expect(order.rates).not_to be_nil
    end
  end

  describe '.retrieve' do
    it 'retrieves an order' do
      order = client.order.create(Fixture.basic_order)
      retrieved_order = client.order.retrieve(order.id)

      expect(retrieved_order).to be_an_instance_of(EasyPost::Models::Order)
      expect(retrieved_order.id).to eq(order.id)
    end
  end

  describe '.get_rates' do
    it 'retrieves rates for an order' do
      order = client.order.create(Fixture.basic_order)
      rates = client.order.get_rates(order.id)

      rates_array = rates.rates

      expect(rates_array).to be_an_instance_of(Array)
      expect(rates_array).to all(be_an_instance_of(EasyPost::Models::Rate))
    end
  end

  describe '.buy' do
    it 'buys an order' do
      order = client.order.create(Fixture.basic_order)

      bought_order = client.order.buy(
        order.id,
        {
          carrier: Fixture.usps,
          service: Fixture.usps_service,
        },
      )

      shipments_array = bought_order.shipments

      shipments_array.each do |shipment|
        expect(shipment.postage_label).not_to be_nil
      end
    end

    it 'buys an order with a rate object' do
      order = client.order.create(Fixture.basic_order)

      bought_order = client.order.buy(order.id, order.lowest_rate)

      shipments_array = bought_order.shipments

      shipments_array.each do |shipment|
        expect(shipment.postage_label).not_to be_nil
      end
    end
  end

  describe '.lowest_rate' do
    it 'tests various usage alterations of the lowest_rate method' do
      shipment = client.order.create(Fixture.basic_order)

      # Test lowest rate with no filters
      lowest_rate = shipment.lowest_rate
      expect(lowest_rate.service).to eq('First')
      expect(lowest_rate.rate).to eq('6.07')
      expect(lowest_rate.carrier).to eq('USPS')

      # Test lowest rate with service filter (this rate is higher than the lowest but should filter)
      lowest_rate = shipment.lowest_rate([], ['Priority'])
      expect(lowest_rate.service).to eq('Priority')
      expect(lowest_rate.rate).to eq('7.15')
      expect(lowest_rate.carrier).to eq('USPS')

      # Test lowest rate with carrier filter (should error due to bad carrier)
      expect {
        shipment.lowest_rate(['BAD CARRIER'], [])
      }.to raise_error(EasyPost::Exceptions::FilteringError, EasyPost::Constants::NO_MATCHING_RATES)
    end
  end
end
